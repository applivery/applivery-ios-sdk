//
//  LoginService.swift
//  Applivery
//
//  Created by Alejandro Jiménez Agudo on 28/03/2019.
//  Copyright © 2019 Applivery S.L. All rights reserved.
//

import Foundation

protocol LoginServiceProtocol {
    func login(loginData: LoginData) async throws
    func bind(user: User) async throws -> AccessToken
    func unbindUser()
    func requestAuthorization()
    func download()
}

final class LoginService: LoginServiceProtocol {

    let loginRepository: LoginRepositoryProtocol
    let configService: ConfigServiceProtocol
    let downloadService: DownloadServiceProtocol
    let globalConfig: GlobalConfig
    let sessionPersister: SessionPersister
    let webViewManager: WebViewManager
    let app: AppProtocol
    
    init(
        loginRepository: LoginRepositoryProtocol = LoginRepository(),
        configService: ConfigServiceProtocol = ConfigService(),
        downloadService: DownloadServiceProtocol = DownloadService(),
        globalConfig: GlobalConfig = GlobalConfig.shared,
        sessionPersister: SessionPersister = SessionPersister(userDefaults: UserDefaults.standard),
        webViewManager: WebViewManager = WebViewManager(),
        app: AppProtocol = App()
    ) {
        self.loginRepository = loginRepository
        self.downloadService = downloadService
        self.configService = configService
        self.globalConfig = globalConfig
        self.sessionPersister = sessionPersister
        self.webViewManager = webViewManager
        self.app = app
    }
    
    func requestAuthorization() {
        globalConfig.accessToken = sessionPersister.loadAccessToken()
        if globalConfig.accessToken == nil {
            logInfo("User authentication is required!")
            Task {
                await openAuthWebView()
            }
        } else {
            download()
        }
    }
    
    func login(loginData: LoginData) async {
        do {
            let accessToken: AccessToken = try await loginRepository.login(loginData: loginData)
            store(accessToken: accessToken, userName: loginData.payload.user)
        } catch {
            log("Access token is not available. Opening auth web view...")
            await openAuthWebView()
        }
    }
    
    func openAuthWebView() async {
        do {
            let redirectURL = try await loginRepository.getRedirctURL()
            if let url = redirectURL {
                webViewManager.showWebView(url: url)
            }
        } catch {
            log("Error obtaining redirect URL: \(error.localizedDescription)")
        }
        
    }
    
    func bind(user: User) async throws -> AccessToken {
        try await loginRepository.bind(user: user)
    }
    
    func unbindUser() {
        loginRepository.unbindUser()
    }
    
    func download() {
        let lastConfig = configService.getCurrentConfig()
        guard let lastBuildId = lastConfig.config?.lastBuildId else {
            return
        }

        Task {
            if let url = await downloadService.downloadURL(lastBuildId) {
                await MainActor.run {
                    if app.openUrl(url) {
                        // Do things here
                    } else {
                        let error = NSError.appliveryError(literal(.errorDownloadURL))
                        logError(error)
                    }
                }
            } else {
                let error = NSError.appliveryError(literal(.errorDownloadURL))
                await MainActor.run {
                    app.showErrorAlert(error.message(), retryHandler: {})
                }
            }
        }
    }
}

private extension LoginService {
    
    func store(accessToken: AccessToken, userName: String) {
        logInfo("Fetched new access token: \(accessToken.token ?? "NO TOKEN")")
        self.sessionPersister.save(accessToken: accessToken)
        self.sessionPersister.saveUserName(userName: userName)
        self.globalConfig.accessToken = accessToken
    }
}
