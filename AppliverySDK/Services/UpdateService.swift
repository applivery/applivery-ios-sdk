//
//  UpdateService.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 21/11/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation
import UIKit

protocol UpdateServiceProtocol {
    func forceUpdate()
    func otaUpdate()
    func downloadLastBuild(onResult: ((UpdateResult) -> Void)?)
    func isUpToDate() -> Bool
    func checkForceUpdate(_ config: SDKData?, version: String) -> Bool
    func checkOtaUpdate(_ config: SDKData?, version: String) -> Bool
    func forceUpdateMessage() -> String
    func setCheckForUpdatesBackground(_ enabled: Bool)
    func handleAppWillEnterForeground()
}


final class UpdateService: UpdateServiceProtocol {
    private let configService: ConfigServiceProtocol
    private let downloadService: DownloadServiceProtocol
	private let app: AppProtocol
    private let loginService: LoginServiceProtocol
    private let globalConfig: GlobalConfig
	private let userDefaults: UserDefaultsProtocol = UserDefaults.standard
    var forceUpdateCalled = false
    
    init(
        configService: ConfigServiceProtocol = ConfigService(),
        downloadService: DownloadServiceProtocol = DownloadService(),
        app: AppProtocol = App(),
        loginService: LoginServiceProtocol = LoginService(),
        globalConfig: GlobalConfig = GlobalConfig.shared
    ) {
        self.configService = configService
        self.downloadService = downloadService
        self.app = app
        self.loginService = loginService
        self.globalConfig = globalConfig
    }
    
    func forceUpdate() {
        logInfo("Opening force update screen")
        guard !forceUpdateCalled else { return }
        forceUpdateCalled = true
        DispatchQueue.main.async { [weak self] in
            self?.app.showForceUpdate()
        }
    }
    
    func otaUpdate() {
        let message = otaUpdateMessage()
        let postponeIntervals = globalConfig.configuration?.postponedTimeFrames ?? []
        DispatchQueue.main.async { [weak self] in
            self?.userDefaults.setValue(Date(), forKey: AppliveryUserDefaultsKeys.appliveryLastUpdatePopupShown)
            self?.app.showOtaAlert(message, allowPostpone: !postponeIntervals.isEmpty) {
                self?.downloadLastBuild()
            } postponeHandler: {
                self?.app.showPostponeSelectionAlert("Postpone update for:", options: postponeIntervals) { interval in
                    self?.userDefaults.setValue(interval, forKey: AppliveryUserDefaultsKeys.appliveryPostponeInterval)
                    logInfo("The popup was postponed for \(interval.formatTimeInterval)")
                }
            }
        }
    }
	
	func forceUpdateMessage() -> String {
		let currentConfig = self.configService.getCurrentConfig()
		
        var message = literal(.forceUpdateMessage) ?? currentConfig.config?.mustUpdateMsg ?? kLocaleForceUpdateMessage
		
		if message == "" {
			message = kLocaleForceUpdateMessage
		}
		
		return message
	}
	
	func otaUpdateMessage() -> String {
		let currentConfig = self.configService.getCurrentConfig()
        var message = literal(.otaUpdateMessage) ?? currentConfig.config?.updateMsg ?? kLocaleOtaUpdateMessage
		
		if message == "" {
			message = kLocaleOtaUpdateMessage
		}
		
		return message
	}
	
	func downloadLastBuild(onResult: ((UpdateResult) -> Void)? = nil) {
        guard let config = self.configService.getCurrentConfig().config else {
            logInfo("No current config found")
            onResult?(.failure(error: .noConfigFound))
            return
		}

        if config.forceAuth {
            logInfo("Force authorization is enabled - requesting authorization")
            loginService.requestAuthorization(onResult: onResult)
        } else {
            logInfo("Force authorization is disabled - downloading last build")
            loginService.download(onResult: onResult)
        }

	}
	
	func isUpToDate() -> Bool {
        let currentConfig = self.configService.getCurrentConfig()
        
        if let minVersion = currentConfig.config?.minVersion,
            let forceUpdate = currentConfig.config?.forceUpdate,
            forceUpdate,
            !minVersion.isEmpty {
            let isOlder = isOlder(currentConfig.version, minVersion: minVersion)
            logInfo("[isUpToDate] - Force update is available, checking if \(currentConfig.version) is older than \(minVersion), Need update: \(!isOlder)")
            return !isOlder
        }
        
        if let lastVersion = currentConfig.config?.lastBuildVersion, !lastVersion.isEmpty {
            let isOlder = isOlder(currentConfig.buildNumber, minVersion: lastVersion)
            logInfo("[isUpToDate] - Last Build version is available, Need update: \(isOlder)")
            return !isOlder
        }
        
        return true
	}
	
    func checkForceUpdate(_ config: SDKData?, version: String) -> Bool {
        guard
            let minVersion = config?.minVersion,
            let forceUpdate = config?.forceUpdate,
            forceUpdate
            else { return false }
        
        logInfo("[checkForceUpdate] - Checking if build version: \(version) is older than minBuildVersion: \(minVersion)")
        if self.isOlder(version, minVersion: minVersion) {
            logInfo("[checkForceUpdate] - Application must be updated!!")
            return true
        }
        
        return false
    }
    
    func checkOtaUpdate(_ config: SDKData?, version: String) -> Bool {
        guard
            let lastVersion = config?.lastBuildVersion,
            let otaUpdate = config?.ota,
            otaUpdate
        else {
            logInfo("[checkOtaUpdate] - ota update not needed")
            return false
        }
        
        logInfo("[checkOtaUpdate] - Checking if app version: \(version) is older than last build version: \(lastVersion)")
        if self.isOlder(version, minVersion: lastVersion) {
            logInfo("[checkOtaUpdate] - New OTA update available!")
            return true
        }
        logInfo("ota update not needed")
        return false
    }
    
    func setCheckForUpdatesBackground(_ enabled: Bool) {
        if enabled {
            if !globalConfig.isForegroundObserverAdded {
                NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(handleAppWillEnterForeground),
                    name: UIApplication.willEnterForegroundNotification,
                    object: nil
                )
            }
            globalConfig.isForegroundObserverAdded = true
            logInfo("Background updates enabled")
        } else {
            if globalConfig.isForegroundObserverAdded {
                NotificationCenter.default.removeObserver(
                    self,
                    name: UIApplication.willEnterForegroundNotification,
                    object: nil
                )
            }
            globalConfig.isForegroundObserverAdded = false
            logInfo("Background updates disabled")
        }
        globalConfig.isCheckForUpdatesBackgroundEnabled = enabled
    }

    @objc func handleAppWillEnterForeground() {
        if globalConfig.isCheckForUpdatesBackgroundEnabled {
            let config = configService.getCurrentConfig()
            if checkOtaUpdate(config.config, version: config.buildNumber) {
                otaUpdate()
            }
            logInfo("App returned from background, checking for updates...")
        }
    }
}

private extension UpdateService {
    func download(with config: SDKData) {
        guard let lastBuildId = config.lastBuildId else {
            return
        }

        Task {
            if let url = await downloadService.downloadURL(lastBuildId) {
                await MainActor.run {
                    if app.openUrl(url) {
                    } else {
                        let error = NSError.appliveryError(literal(.errorDownloadURL))
                        logError(error)
                    }
                }
            } else {
                let error = NSError.appliveryError(literal(.errorDownloadURL))
                logError(error)
            }
        }
    }
    
    func isOlder(_ currentVersion: String, minVersion: String) -> Bool {
        let (current, min) = self.equalLengthFillingWithZeros(left: currentVersion, right: minVersion)
        let result = current.compare(min, options: NSString.CompareOptions.numeric, range: nil, locale: nil)
        
        return result == ComparisonResult.orderedAscending
    }
    
    func equalLengthFillingWithZeros(left: String, right: String) -> (String, String) {
        let componentsLeft = left.components(separatedBy: ".")
        let componentsRight = right.components(separatedBy: ".")
        
        if componentsLeft.count == componentsRight.count {
            return (left, right)
        } else if componentsLeft.count < componentsRight.count {
            let dif = componentsRight.count - componentsLeft.count
            let leftFilled = self.fillWithZeros(string: componentsLeft, length: dif)
            return (leftFilled, right)
        } else {
            let dif = componentsLeft.count - componentsRight.count
            let rightFilled = self.fillWithZeros(string: componentsRight, length: dif)
            return (left, rightFilled)
        }
    }
    
    func fillWithZeros(string: [String], length: Int) -> String {
        var zeroFilledString = string
        for _ in 1...length {
            zeroFilledString.append("0")
        }
        
        return zeroFilledString.joined(separator: ".")
    }
}
