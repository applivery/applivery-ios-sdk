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
        updateService: UpdateServiceProtocol = UpdateService(eventDetector: BackgroundDetector()),
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
        self.updateConfig()
    }

    func enableFeedback() {
        self.globalConfig.feedbackEnabled = true
        eventDetector.listenEvent {
            ScreenRecorderManager.shared.presentPreviewWithScreenshoot()
        }
    }

    func disableFeedback() {
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
                self.updateService.checkUpdate(for: updateConfig, forceUpdate: false)
            } catch APIError.statusCode(let statusCode) {
                if statusCode == 401 {
                    await showLoginAlert()
                } else {
                    let currentConfig = self.configService.getCurrentConfig()
                    self.updateService.checkUpdate(for: currentConfig, forceUpdate: false)
                }
            }
        }
    }

    func checkUpdate(forceUpdate: Bool = false) {
        let config = configService.getCurrentConfig()
        updateService.checkUpdate(for: config, forceUpdate: forceUpdate)
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
}
