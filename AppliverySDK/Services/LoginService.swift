//
//  LoginService.swift
//  Applivery
//
//  Created by Alejandro Jiménez Agudo on 28/03/2019.
//  Copyright © 2019 Applivery S.L. All rights reserved.
//

import Foundation
import UIKit

protocol LoginServiceProtocol {
    func login(loginData: LoginData) async throws
    func bind(user: User) async throws -> AccessToken
    func unbindUser()
    func getRedirectURL() async throws -> URL?
    func requestAuthorization()
    func download()
}

final class LoginService: LoginServiceProtocol {

    let loginRepository: LoginRepositoryProtocol
    let configService: ConfigServiceProtocol
    let downloadService: DownloadServiceProtocol
    let globalConfig: GlobalConfig
    let sessionPersister: SessionPersister
    let safariManager: AppliverySafariManagerProtocol
    let app: AppProtocol
    let keychain: KeychainAccessible
    
    init(
        loginRepository: LoginRepositoryProtocol = LoginRepository(),
        configService: ConfigServiceProtocol = ConfigService(),
        downloadService: DownloadServiceProtocol = DownloadService(),
        globalConfig: GlobalConfig = GlobalConfig.shared,
        sessionPersister: SessionPersister = SessionPersister(userDefaults: UserDefaults.standard),
        webViewManager: AppliverySafariManagerProtocol = AppliverySafariManager.shared,
        app: AppProtocol = App(),
        keychain: KeychainAccessible = Keychain()
    ) {
        self.loginRepository = loginRepository
        self.downloadService = downloadService
        self.configService = configService
        self.globalConfig = globalConfig
        self.sessionPersister = sessionPersister
        self.safariManager = webViewManager
        self.app = app
        self.keychain = keychain
    }
    
    func requestAuthorization() {
        
        do {
            let token = try keychain.retrieve(for: app.bundleId())
            globalConfig.accessToken = AccessToken(token: token)
            download()
        } catch {
            logInfo("User authentication is required!")
            Task {
                await openAuthWebView()
            }
        }
    }
    
    func login(loginData: LoginData) async {
        do {
            logInfo("Logging in...")
            let accessToken: AccessToken = try await loginRepository.login(loginData: loginData)
            store(accessToken: accessToken, userName: loginData.payload.user)
        } catch APIError.statusCode(let errorCode) {
            if errorCode == 401 {
                log("Access token is not available. Opening auth web view...")
                await openAuthWebView()
            }
        } catch {
            log("Access token is not available. \(error)")
        }
    }
    
    func getRedirectURL() async throws -> URL? {
        return try await loginRepository.getRedirctURL()
    }
    
    @MainActor
    func openAuthWebView() async {
        do {
            logInfo("Opening auth web view...")
            let redirectURL = try await loginRepository.getRedirctURL()
            
            if let url = redirectURL,
               let topController = app.topViewController() {
                safariManager.openSafari(from: url, from: topController)
            }
        } catch {
            log("Error obtaining redirect URL: \(error.localizedDescription)")
            app.showErrorAlert("Error obtaining redirect URL", retryHandler: {})
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
                logError(error)
                await openAuthWebView()
            }
        }
    }
}

private extension LoginService {
    
    func store(accessToken: AccessToken, userName: String) {
        logInfo("Fetched new access token: \(accessToken.token ?? "NO TOKEN")")
        if let token = accessToken.token {
            do {
                try keychain.store(token, for: app.bundleId())
                self.sessionPersister.saveUserName(userName: userName)
                self.globalConfig.accessToken = accessToken
            } catch {
                app.showErrorAlert("", retryHandler: {})
            }
        }
        
        
    }
}
