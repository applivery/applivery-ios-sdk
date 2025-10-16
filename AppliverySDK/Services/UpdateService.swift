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
    func isUpToDate() async throws -> Bool
    func checkForceUpdate(_ config: SDKData?, version: String) -> Bool
    func checkOtaUpdate(_ config: SDKData?, version: String, buildNumber: String) -> Bool
    func forceUpdateMessage() -> String
    func setCheckForUpdatesBackground(_ enabled: Bool)
    func checkUpdate(for updateConfig: UpdateConfigResponse, forceUpdate: Bool)
}


final class UpdateService: UpdateServiceProtocol {
    private let configService: ConfigServiceProtocol
    private let downloadService: DownloadServiceProtocol
    private let app: AppProtocol
    private let loginService: LoginServiceProtocol
    private let globalConfig: GlobalConfig
    private let eventDetector: EventDetector
    private let userDefaults: UserDefaultsProtocol = UserDefaults.standard
    var forceUpdateCalled = false

    init(
        configService: ConfigServiceProtocol = ConfigService(),
        downloadService: DownloadServiceProtocol = DownloadService(),
        app: AppProtocol = App(),
        loginService: LoginServiceProtocol = LoginService(),
        globalConfig: GlobalConfig = GlobalConfig.shared,
        eventDetector: EventDetector
    ) {
        self.configService = configService
        self.downloadService = downloadService
        self.app = app
        self.loginService = loginService
        self.globalConfig = globalConfig
        self.eventDetector = eventDetector
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

    func isUpToDate() async throws -> Bool {
         let currentConfig = configService.getCurrentConfig()
         do {
             let config = try await configService.fetchConfig()
             let forceUpdate = config.data.sdk.ios.forceUpdate
             if let minVersion = config.data.sdk.ios.minVersion, forceUpdate, !minVersion.isEmpty {
                 let isOlder = isOlder(version: currentConfig.version, buildNumber: currentConfig.buildNumber, thanVersion: minVersion, thanBuildNumber: "0")
                 logInfo("[isUpToDate] - Force update is available, checking if \(currentConfig.version) is older than \(minVersion), Need update: \(!isOlder)")
                 return !isOlder
             }
             if let lastVersion = config.data.sdk.ios.lastBuildVersion, !lastVersion.isEmpty {
                 let isOlder = isOlder(version: currentConfig.version, buildNumber: currentConfig.buildNumber, thanVersion: currentConfig.version, thanBuildNumber: lastVersion)
                 logInfo("[isUpToDate] - Last Build version is available, Need update: \(isOlder)")
                 return !isOlder
             }
             return true
         } catch {
             logInfo("[isUpToDate] - fetchConfig failed: \(error). Falling back to currentConfig minVersion check.")
             if let minVersion = currentConfig.config?.minVersion, !minVersion.isEmpty {
                 let isOlder = isOlder(version: currentConfig.version, buildNumber: currentConfig.buildNumber, thanVersion: minVersion, thanBuildNumber: "0")
                 logInfo("[isUpToDate] - Fallback: checking if \(currentConfig.version) is older than \(minVersion), Need update: \(!isOlder)")
                 return !isOlder
             }
             return true
         }
     }

    func checkForceUpdate(_ config: SDKData?, version: String) -> Bool {
        guard
            let minVersion = config?.minVersion,
            let forceUpdate = config?.forceUpdate,
            forceUpdate
            else { return false }

        let currentBuildNumber = configService.getCurrentConfig().buildNumber
        logInfo("[checkForceUpdate] - Checking if app version: \(version) (build: \(currentBuildNumber)) is older than min version: \(minVersion)")
        if self.isOlder(version: version, buildNumber: currentBuildNumber, thanVersion: minVersion, thanBuildNumber: "0") {
            logInfo("[checkForceUpdate] - Application must be updated!!")
            return true
        }

        return false
    }

    func checkOtaUpdate(_ config: SDKData?, version: String, buildNumber: String) -> Bool {
        guard
            let lastVersion = config?.lastBuildVersion,
            let otaUpdate = config?.ota,
            otaUpdate
        else {
            logInfo("[checkOtaUpdate] - ota update not needed")
            return false
        }

        // Keep semantic version neutral by using the same version on both sides; compare build numbers
        logInfo("[checkOtaUpdate] - Checking if app (version: \(version), build: \(buildNumber)) is older than last build version: \(lastVersion)")
        if self.isOlder(version: version, buildNumber: buildNumber, thanVersion: version, thanBuildNumber: lastVersion) {
            logInfo("[checkOtaUpdate] - New OTA update available!")
            return true
        }
        logInfo("ota update not needed")
        return false
    }

    func setCheckForUpdatesBackground(_ enabled: Bool) {
        if enabled {
            eventDetector.listenEvent {
                Task {
                    do {
                        // Fetch fresh config from server to ensure we have the latest update information
                        let freshConfig = try await self.configService.updateConfig()
                        self.checkUpdate(for: freshConfig, forceUpdate: false)
                    } catch {
                        // Fallback to current config if fetch fails
                        let currentConfig = self.configService.getCurrentConfig()
                        self.checkUpdate(for: currentConfig, forceUpdate: false)
                    }
                }
            }
        } else {
            eventDetector.endListening()
        }
    }

    func checkUpdate(for updateConfig: UpdateConfigResponse, forceUpdate: Bool) {
        let appVersion = app.getVersion()
        let currentConfig = configService.getCurrentConfig()
        let appBuildNumber = currentConfig.buildNumber
        // use existing helpers to determine if a force or ota update is needed
        if forceUpdate && checkForceUpdate(updateConfig.config, version: appVersion) {
            logInfo("Performing force update...")
            self.forceUpdate()
            return
        }

        if checkOtaUpdate(updateConfig.config, version: appVersion, buildNumber: appBuildNumber) {
            if shouldShowPopup() {
                logInfo("Performing OTA update...")
                otaUpdate()
            } else {
                logInfo("CheckUpdates finished: Updates were postponed")
            }
            return
        }

        logInfo("CheckUpdates finished: No Update needed")
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

    func shouldShowPopup() -> Bool {
        if let storedDate = UserDefaults.standard.object(forKey: AppliveryUserDefaultsKeys.appliveryLastUpdatePopupShown) as? Date,
           let interval = UserDefaults.standard.object(forKey: AppliveryUserDefaultsKeys.appliveryPostponeInterval) as? TimeInterval {
            let elapsedTime = Date().timeIntervalSince(storedDate)
            logInfo("Elapsed Time: \(elapsedTime) interval: \(interval)")
            return elapsedTime >= interval
        } else {
            logInfo("Elapsed Time or interval not found, showing popup")
            return true
        }
    }

    func isOlder(_ currentVersion: String, minVersion: String) -> Bool {
        let (current, min) = self.equalLengthFillingWithZeros(left: currentVersion, right: minVersion)
        let result = current.compare(min, options: NSString.CompareOptions.numeric, range: nil, locale: nil)

        return result == ComparisonResult.orderedAscending
    }

    // New helper to compare semantic version + build number pairs.
    // Returns true if (version, buildNumber) is older than (thanVersion, thanBuildNumber).
    func isOlder(version: String, buildNumber: String, thanVersion: String, thanBuildNumber: String) -> Bool {
        // Compare semantic versions first
        let leftVersion = version.isEmpty ? "0" : version
        let rightVersion = thanVersion.isEmpty ? "0" : thanVersion
        let (leftFilled, rightFilled) = self.equalLengthFillingWithZeros(left: leftVersion, right: rightVersion)
        let versionComparison = leftFilled.compare(rightFilled, options: .numeric, range: nil, locale: nil)

        switch versionComparison {
        case .orderedAscending:
            return true // current version older than target version
        case .orderedDescending:
            return false // current version newer than target version
        case .orderedSame:
            // If versions are equal, compare build numbers numerically
            let leftBuild = buildNumber.isEmpty ? "0" : buildNumber
            let rightBuild = thanBuildNumber.isEmpty ? "0" : thanBuildNumber
            let buildComparison = leftBuild.compare(rightBuild, options: .numeric, range: nil, locale: nil)
            return buildComparison == .orderedAscending
        }
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

    @objc func handleAppWillEnterForeground() {
        if globalConfig.isCheckForUpdatesBackgroundEnabled {
            let config = configService.getCurrentConfig()
            let version = app.getVersion()
            if checkOtaUpdate(config.config, version: version, buildNumber: config.buildNumber) {
                otaUpdate()
            }
            logInfo("App returned from background, checking for updates...")
        }
    }
}
