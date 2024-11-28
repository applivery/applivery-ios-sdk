//
//  LoginService.swift
//  Applivery
//
//  Created by Alejandro Jiménez Agudo on 10/3/18.
//  Copyright © 2018 Applivery S.L. All rights reserved.
//

import Foundation

struct LoginData: Encodable {
    let provider: String
    let payload: UserData
    
}

struct UserData: Encodable {
    let user: String
    let password: String
}

protocol LoginServiceProtocol {
    func login(loginData: LoginData) async throws -> AccessToken
    func bind(user: User) async throws -> AccessToken
}

final class LoginService: LoginServiceProtocol {
    
    private let client: APIClientProtocol
    
    init(client: APIClientProtocol = APIClient()) {
        self.client = client
    }
	
    func login(loginData: LoginData) async throws -> AccessToken {
        let endpoint: AppliveryEndpoint = .login(loginData)
        let accessToken: AccessToken = try await client.fetch(endpoint: endpoint)
        return accessToken
    }
    
    func bind(user: User) async throws -> AccessToken {
        let endpoint: AppliveryEndpoint = .bind(user)
        let accessToken: AccessToken = try await client.fetch(endpoint: endpoint)
        return accessToken
    }
}
