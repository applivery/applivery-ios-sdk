//
//  LoginDataManager.swift
//  Applivery
//
//  Created by Alejandro Jiménez Agudo on 28/03/2019.
//  Copyright © 2019 Applivery S.L. All rights reserved.
//

import Foundation

protocol LoginDataManagerProtocol {
    func login(loginData: LoginData) async throws -> AccessToken
    func bind(user: User) async throws -> AccessToken
}

final class LoginDataManager: LoginDataManagerProtocol {

	let loginService: LoginServiceProtocol
    
    init(loginService: LoginServiceProtocol = LoginService()) {
        self.loginService = loginService
    }
    
    func login(loginData: LoginData) async throws -> AccessToken {
        try await loginService.login(loginData: loginData)
    }
    
    func bind(user: User) async throws -> AccessToken {
        try await loginService.bind(user: user)
    }
	
}
