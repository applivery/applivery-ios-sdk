//
//  StartInteractor.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 4/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation
import Combine

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
    private let updateService: UpdateServiceProtocol
    private let webViewManager: WebViewManager
    private let loginRepository: LoginRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Initializers
    
    init(
        app: AppProtocol = App(),
        configService: ConfigServiceProtocol = ConfigService(),
        globalConfig: GlobalConfig = GlobalConfig.shared,
        eventDetector: EventDetector = ScreenshotDetector(),
        sessionPersister: SessionPersister = SessionPersister(userDefaults: UserDefaults.standard),
        updateService: UpdateServiceProtocol = UpdateService(),
        webViewManager: WebViewManager = WebViewManager(),
        loginRepository: LoginRepositoryProtocol = LoginRepository()
    ) {
        self.app = app
        self.configService = configService
        self.globalConfig = globalConfig
        self.eventDetector = eventDetector
        self.sessionPersister = sessionPersister
        self.updateService = updateService
        self.webViewManager = webViewManager
        self.loginRepository = loginRepository
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
        self.eventDetector.listenEvent(app.presentFeedbackForm)
        self.updateConfig()
    }
    
    func disableFeedback() {
        guard self.globalConfig.feedbackEnabled else { return }
        
        self.globalConfig.feedbackEnabled = false
        self.eventDetector.endListening()
    }
    
    // MARK: Private Methods
    
    private func updateConfig() {
        self.globalConfig.accessToken = self.sessionPersister.loadAccessToken()
        
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
            self.sessionPersister.save(accessToken: .init(token: token))
            self.updateConfig()
        }
        .store(in: &cancellables)
    }
    
    func checkUpdate(for updateConfig: UpdateConfigResponse) {
        if self.updateService.checkForceUpdate(updateConfig.config, version: updateConfig.version) {
            updateService.forceUpdate()
        } else if self.updateService.checkOtaUpdate(updateConfig.config, version: updateConfig.version) {
            updateService.otaUpdate()
        }
    }
    
    func openAuthWebView() async {
        do {
            logInfo("Opening auth web view...")
            let redirectURL = try await loginRepository.getRedirctURL()
            await MainActor.run {
                if let url = redirectURL {
                    webViewManager.showWebView(url: url)
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
