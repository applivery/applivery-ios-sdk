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
    func bind(user: User) async throws
    func unbindUser()
    func getRedirectURL() async throws -> URL?
    func requestAuthorization(onResult: ((UpdateResult) -> Void)?)
    func download(onResult: ((UpdateResult) -> Void)?)
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
    
    func requestAuthorization(onResult: ((UpdateResult) -> Void)?) {

        do {
            let token = try keychain.retrieve(for: app.bundleId())
            globalConfig.accessToken = AccessToken(token: token)
            download(onResult: onResult)
        } catch {
            logInfo("User authentication is required!")
            onResult?(.failure(error: .authRequired))
        }
    }
    
    func login(loginData: LoginData) async {
        do {
            logInfo("Logging in...")
            let accessToken: AccessToken = try await loginRepository.login(loginData: loginData)
            store(accessToken: accessToken, userName: loginData.payload.user)
        } catch APIError.statusCode(let errorCode) {
            if errorCode == 401 {
                logInfo("Access token is not available. Opening auth web view...")
                await openAuthWebView()
            }
        } catch {
            logInfo("Access token is not available. \(error)")
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
            logInfo("Error obtaining redirect URL: \(error)")
            app.showErrorAlert("Error obtaining redirect URL")
        }
    }
    
    @MainActor
    func bind(user: User) async throws {
        do {
            let userData = try await loginRepository.bind(user: user)
            store(accessToken: .init(token: userData.data.bearer), userName: userData.data.member.email)
        } catch {
            logInfo("Error binding user: \(error)")
            app.showErrorAlert("Error binding user")
        }
    }
    
    func unbindUser() {
        loginRepository.unbindUser()
    }
    
    func download(onResult: ((UpdateResult) -> Void)? = nil) {
        let lastConfig = configService.getCurrentConfig()
        guard let lastBuildId = lastConfig.config?.lastBuildId else {
            onResult?(.failure(error: .noConfigFound))
            return
        }

        Task {
            if let url = await downloadService.downloadURL(lastBuildId) {
                await MainActor.run {
                    if app.openUrl(url) {
                        onResult?(.success())
                    }
                    else {
                        let error = NSError.appliveryError(literal(.errorDownloadURL))
                        logError(error)
                        onResult?(.failure(error: .downloadManifestError))
                    }
                }
            } else {
                let error = NSError.appliveryError(literal(.errorDownloadURL))
                logError(error)
                onResult?(.failure(error: .downloadUrlNotFound))
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
                logError(error as NSError)
                app.showErrorAlert("Error storing token")
            }
        }
    }
}
