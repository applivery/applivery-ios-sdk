//
//  UpdateService.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 21/11/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation

protocol UpdateServiceProtocol {
	
    func forceUpdate()
    func otaUpdate()
	func downloadLastBuild(onResult: ((UpdateResult) -> Void)?)
	func isUpToDate() -> Bool
    func checkForceUpdate(_ config: SDKData?, version: String) -> Bool
    func checkOtaUpdate(_ config: SDKData?, version: String) -> Bool
    func forceUpdateMessage() -> String
}


final class UpdateService: UpdateServiceProtocol {
    	
    private let configService: ConfigServiceProtocol
    private let downloadService: DownloadServiceProtocol
	private let app: AppProtocol
    private let loginService: LoginServiceProtocol
	private let globalConfig: GlobalConfig
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
        DispatchQueue.main.async { [weak self] in
            self?.app.showOtaAlert(message) {
                self?.downloadLastBuild()
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
        if isUpToDate() {
            onResult?(.failure(error: .isUpToDate))
        } else {
            if config.forceAuth {
                logInfo("Force authorization is enabled - requesting authorization")
                loginService.requestAuthorization(onResult: onResult)
            } else {
                logInfo("Force authorization is disabled - downloading last build")
                loginService.download(onResult: onResult)
            }
        }

	}
	
	func isUpToDate() -> Bool {
        let currentConfig = self.configService.getCurrentConfig()
        
        if let minVersion = currentConfig.config?.minVersion, !minVersion.isEmpty {
            let isOlder = isOlder(currentConfig.version, minVersion: minVersion)
            logInfo("Min version is available, Need update: \(isOlder)")
            return !isOlder
        }
        
        if let lastVersion = currentConfig.config?.lastBuildVersion, !lastVersion.isEmpty {
            let isOlder = isOlder(currentConfig.buildNumber, minVersion: lastVersion)
            logInfo("Last version is available, Need update: \(isOlder)")
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
        
        logInfo("Checking if app version: \(version) is older than minVersion: \(minVersion)")
        if self.isOlder(version, minVersion: minVersion) {
            logInfo("Application must be updated!!")
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
            logInfo("ota update not needed")
            return false
        }
        
        logInfo("Checking if app version: \(version) is older than last build version: \(lastVersion)")
        if self.isOlder(version, minVersion: lastVersion) {
            logInfo("New OTA update available!")
            return true
        }
		return false
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
