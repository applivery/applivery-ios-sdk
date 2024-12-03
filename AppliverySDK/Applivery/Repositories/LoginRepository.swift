//
//  LoginRepository.swift
//  Applivery
//
//  Created by Alejandro Jiménez Agudo on 10/3/18.
//  Copyright © 2018 Applivery S.L. All rights reserved.
//

import Foundation
struct RedirectInfo: Decodable {
    let url: String
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
    func bind(user: User) async throws -> AccessToken
    func unbindUser()
    func getRedirctURL() async throws -> URL?
}

final class LoginRepository: LoginRepositoryProtocol {
    
    private let client: APIClientProtocol
    private let globalConfig: GlobalConfig
    private let sessionPersister: SessionPersister
    
    init(
        client: APIClientProtocol = APIClient(),
        globalConfig: GlobalConfig = GlobalConfig.shared,
        sessionPersister: SessionPersister = SessionPersister(userDefaults: UserDefaults.standard)
    ) {
        self.client = client
        self.globalConfig = globalConfig
        self.sessionPersister = sessionPersister
    }
	
    func login(loginData: LoginData) async throws -> AccessToken {
        let endpoint: AppliveryEndpoint = .login(loginData)
        let accessToken: AccessToken = try await client.fetch(endpoint: endpoint)
        return accessToken
    }
    
    func getRedirctURL() async throws -> URL? {
        let endpoint: AppliveryEndpoint = .redirect
        let url: RedirectInfo = try await client.fetch(endpoint: endpoint)
        return URL(string: url.url)
    }
    
    func bind(user: User) async throws -> AccessToken {
        let endpoint: AppliveryEndpoint = .bind(user)
        let accessToken: AccessToken = try await client.fetch(endpoint: endpoint)
        return accessToken
    }
    
    func unbindUser() {
        logInfo("Unbinding user...")
        self.sessionPersister.save(accessToken: nil)
        self.sessionPersister.removeUser()
        self.globalConfig.accessToken = nil
    }
}
