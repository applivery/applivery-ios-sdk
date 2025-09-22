//
//  StartInteractor.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 4/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation
import Combine
import UIKit

protocol StartInteractorOutput {
    func forceUpdate()
    func otaUpdate()
    func feedbackEvent()
    func credentialError(message: String)
}

final class StartInteractor {
        
    private let app: AppProtocol
    private let configService: ConfigServiceProtocol
    private let globalConfig: GlobalConfig
    private let eventDetector: EventDetector
    private let sessionPersister: SessionPersister
    private let keychain: KeychainAccessible
    private let updateService: UpdateServiceProtocol
    private let safariManager: AppliverySafariManagerProtocol
    private let loginService: LoginServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Initializers
    
    init(
        app: AppProtocol = App(),
        configService: ConfigServiceProtocol = ConfigService(),
        globalConfig: GlobalConfig = GlobalConfig.shared,
        eventDetector: EventDetector = ScreenshotDetector(),
        sessionPersister: SessionPersister = SessionPersister(userDefaults: UserDefaults.standard),
        keychain: KeychainAccessible = Keychain(),
        updateService: UpdateServiceProtocol = UpdateService(),
        webViewManager: AppliverySafariManagerProtocol = AppliverySafariManager.shared,
        loginService: LoginServiceProtocol = LoginService()
    ) {
        self.app = app
        self.configService = configService
        self.globalConfig = globalConfig
        self.eventDetector = eventDetector
        self.sessionPersister = sessionPersister
        self.keychain = keychain
        self.updateService = updateService
        self.safariManager = webViewManager
        self.loginService = loginService
    }
    
    
    // MARK: Internal Methods
    
    func start(skipUpdateCheck: Bool) {
        if !skipUpdateCheck {
            checkUpdate(forceUpdate: false)
        }
        logInfo("Applivery is starting... ")
        logInfo("SDK Version: \(GlobalConfig.shared.app.getSDKVersion())")
        setupBindings()
        guard !self.globalConfig.appToken.isEmpty else {
            logInfo("App token is empty")
            return
        }
        self.eventDetector.listenEvent(
            ScreenRecorderManager.shared.presentPreviewWithScreenshoot
        )
        self.updateConfig()
    }
    
    func disableFeedback() {
        guard self.globalConfig.feedbackEnabled else { return }
        
        self.globalConfig.feedbackEnabled = false
        self.eventDetector.endListening()
    }
    
    // MARK: Private Methods
    
    func updateConfig() {
        self.globalConfig.accessToken = .init(
            token: try? keychain.retrieve(for: app.bundleId())
        )
        
        Task {
            do {
                let updateConfig = try await configService.updateConfig()
                self.checkUpdate(for: updateConfig, forceUpdate: false)
            } catch APIError.statusCode(let statusCode) {
                if statusCode == 401 {
                    await showLoginAlert()
                } else {
                    let currentConfig = self.configService.getCurrentConfig()
                    self.checkUpdate(for: currentConfig, forceUpdate: false)
                }
            }
        }
    }
    
    func checkUpdate(forceUpdate: Bool = false) {
        let config = configService.getCurrentConfig()
        checkUpdate(for: config, forceUpdate: forceUpdate)
    }
    
    @MainActor
    private func showLoginAlert() {
        logInfo("Presenting login alert")
        app
            .showLoginAlert(
                isCancellable: !(globalConfig.configuration?.enforceAuthentication ?? false)
            ) {
            Task {
                await self.openAuthWebView()
            }
        }
    }
    
}

private extension StartInteractor {
    
    func setupBindings() {
        safariManager.tokenPublisher.sink { token in
            guard let token else { return }
            do {
                try self.keychain.store(token, for: self.app.bundleId())
                self.updateConfig()
            } catch {
                logError(error as NSError)
            }
        }
        .store(in: &cancellables)
    }
    
    func checkUpdate(for updateConfig: UpdateConfigResponse, forceUpdate: Bool) {
        let appVersion = app.getVersion()
        var minVersion = updateConfig.config?.minVersion ?? "-1"
        minVersion = minVersion.isEmpty ? "-1" : minVersion
        let otaEnabled = updateConfig.config?.ota ?? false
        var lastBuildVersion = updateConfig.config?.lastBuildVersion ?? "-1"
        lastBuildVersion = lastBuildVersion.isEmpty ? "-1" : lastBuildVersion

        if forceUpdate && isVersionNewer(v1: minVersion, than: appVersion) {
            logInfo("Performing force update...")
            updateService.forceUpdate()
        } else if otaEnabled && isVersionNewer(v1: lastBuildVersion, than: appVersion) {
            if shouldShowPopup() {
                logInfo("Performing OTA update...")
                updateService.otaUpdate()
            } else {
                logInfo("CheckUpdates finished: Updates were postponed")
            }
        } else {
            logInfo("CheckUpdates finished: No Update needed")
        }
    }
    
    func openAuthWebView() async {
        do {
            logInfo("Opening auth web view...")
            let redirectURL = try await loginService.getRedirectURL()
            await MainActor.run {
                if let url = redirectURL,
                   let topController = app.topViewController() {
                    safariManager.openSafari(from: url, from: topController)
                }
            }
        } catch {
            logInfo("Error obtaining redirect URL: \(error)")
            await MainActor.run {
                app.showErrorAlert("Error obtaining redirect URL")
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

    func isVersionNewer(v1: String, than v2: String) -> Bool {
        if v1.isEmpty || v1 == "-1" { return false }
        if v2.isEmpty || v2 == "-1" { return true }

        let v1Parts = v1.split(separator: ".").compactMap { Int($0) }
        let v2Parts = v2.split(separator: ".").compactMap { Int($0) }
        let maxCount = max(v1Parts.count, v2Parts.count)
        for i in 0..<maxCount {
            let part1 = i < v1Parts.count ? v1Parts[i] : 0
            let part2 = i < v2Parts.count ? v2Parts[i] : 0
            if part1 > part2 { return true }
            if part1 < part2 { return false }
        }
        return false // versions are equal
    }
}
