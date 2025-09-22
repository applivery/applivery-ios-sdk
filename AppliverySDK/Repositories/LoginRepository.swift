//
//  LoginRepository.swift
//  Applivery
//
//  Created by Alejandro Jiménez Agudo on 10/3/18.
//  Copyright © 2018 Applivery S.L. All rights reserved.
//

import Foundation
struct RedirectInfo: Decodable {
    let status: Bool
    let data: RedirectInfoData
}

struct RedirectInfoData: Decodable {
    let redirectUrl: String
}

struct LoginData: Encodable {
    let provider: String
    let payload: UserData
}

struct UserData: Encodable {
    let user: String
    let password: String
}

protocol LoginRepositoryProtocol {
    func login(loginData: LoginData) async throws -> AccessToken
    func bind(user: User) async throws -> CustomLogin
    func unbindUser()
    func getRedirctURL() async throws -> URL?
}

final class LoginRepository: LoginRepositoryProtocol {
    
    private let client: APIClientProtocol
    private let globalConfig: GlobalConfig
    private let sessionPersister: SessionPersister
    private let app: AppProtocol
    private let keychain: KeychainAccessible
    
    init(
        client: APIClientProtocol = APIClient(),
        globalConfig: GlobalConfig = GlobalConfig.shared,
        sessionPersister: SessionPersister = SessionPersister(userDefaults: UserDefaults.standard),
        app: AppProtocol = App(),
        keychain: KeychainAccessible = Keychain()
    ) {
        self.client = client
        self.globalConfig = globalConfig
        self.sessionPersister = sessionPersister
        self.app = app
        self.keychain = keychain
    }
	
    func login(loginData: LoginData) async throws -> AccessToken {
        logInfo("Logging in...")
        let endpoint: AppliveryEndpoint = .login(loginData)
        let accessToken: AccessToken = try await client.fetch(endpoint: endpoint)
        return accessToken
    }
    
    func getRedirctURL() async throws -> URL? {
        logInfo("Getting redirect URL...")
        let endpoint: AppliveryEndpoint = .redirect
        let url: RedirectInfo = try await client.fetch(endpoint: endpoint)
        let sanitizedbundleId = app.bundleId().replacingOccurrences(of: ".", with: "-")
        let urlWithSchema = URL(string: "\(url.data.redirectUrl)?scheme=applivery-\(sanitizedbundleId)")
        logInfo("Redirect URL: \(urlWithSchema?.absoluteString ?? "")")
        return urlWithSchema
    }
    
    func bind(user: User) async throws -> CustomLogin {
        logInfo("Binding user...")
        let endpoint: AppliveryEndpoint = .bind(user)
        let accessToken: CustomLogin = try await client.fetch(endpoint: endpoint)
        return accessToken
    }
    
    func unbindUser() {
        logInfo("Unbinding user...")
        try? keychain.remove(for: app.bundleId())
        self.sessionPersister.removeUser()
        self.globalConfig.accessToken = nil
    }
}
