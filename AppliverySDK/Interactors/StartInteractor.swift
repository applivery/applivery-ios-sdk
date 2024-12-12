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

class StartInteractor {
        
    private let app: AppProtocol
    private let configService: ConfigServiceProtocol
    private let globalConfig: GlobalConfig
    private let eventDetector: EventDetector
    private let sessionPersister: SessionPersister
    private let keychain: KeychainAccessible
    private let updateService: UpdateServiceProtocol
    private let webViewManager: AppliveryWebViewManagerProtocol
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
        webViewManager: AppliveryWebViewManagerProtocol = AppliveryWebViewManager.shared,
        loginService: LoginServiceProtocol = LoginService()
    ) {
        self.app = app
        self.configService = configService
        self.globalConfig = globalConfig
        self.eventDetector = eventDetector
        self.sessionPersister = sessionPersister
        self.keychain = keychain
        self.updateService = updateService
        self.webViewManager = webViewManager
        self.loginService = loginService
    }
    
    
    // MARK: Internal Methods
    
    func start() {
        logInfo("Applivery is starting... ")
        logInfo("SDK Version: \(GlobalConfig.shared.app.getSDKVersion())")
        setupBindings()
        guard !self.globalConfig.appToken.isEmpty else {
            logInfo("App token is empty")
            return
        }
        self.eventDetector.listenEvent(ScreenRecorderManager.shared.presentPreviewWithScreenshoot)
        self.updateConfig()
    }
    
    func disableFeedback() {
        guard self.globalConfig.feedbackEnabled else { return }
        
        self.globalConfig.feedbackEnabled = false
        self.eventDetector.endListening()
    }
    
    // MARK: Private Methods
    
    private func updateConfig() {
        self.globalConfig.accessToken = .init(token: try? keychain.retrieve(for: app.bundleId()))
        
        Task {
            do {
                let updateConfig = try await configService.updateConfig()
                self.checkUpdate(for: updateConfig)
            } catch APIError.statusCode(let statusCode) {
                if statusCode == 401 {
                    await openAuthWebView()
                } else {
                    let currentConfig = self.configService.getCurrentConfig()
                    self.checkUpdate(for: currentConfig)
                }
            }
        }
    }
    
}

private extension StartInteractor {
    
    func setupBindings() {
        webViewManager.tokenPublisher.sink { token in
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
    
    func checkUpdate(for updateConfig: UpdateConfigResponse) {
        if self.updateService.checkForceUpdate(updateConfig.config, version: updateConfig.version) {
            updateService.forceUpdate()
        } else if self.updateService.checkOtaUpdate(updateConfig.config, version: updateConfig.bundleVersion) {
            updateService.otaUpdate()
        }
    }
    
    func openAuthWebView() async {
        do {
            logInfo("Opening auth web view...")
            let redirectURL = try await loginService.getRedirectURL()
            await MainActor.run {
                if let url = redirectURL,
                   let rootViewController = UIApplication.shared.windows.first?.rootViewController  {
                    webViewManager.showWebView(url: url, from: rootViewController)
                }
            }
        } catch {
            log("Error obtaining redirect URL: \(error.localizedDescription)")
            await MainActor.run {
                app.showErrorAlert("Error obtaining redirect URL: \(error)", retryHandler: {})
            }
        }
    }
}