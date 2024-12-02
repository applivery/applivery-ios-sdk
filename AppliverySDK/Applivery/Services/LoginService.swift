//
//  LoginService.swift
//  Applivery
//
//  Created by Alejandro Jiménez Agudo on 28/03/2019.
//  Copyright © 2019 Applivery S.L. All rights reserved.
//

import Foundation

protocol LoginServiceProtocol {
    func login(loginData: LoginData) async throws -> AccessToken
    func bind(user: User) async throws -> AccessToken
}

final class LoginService: LoginServiceProtocol {

    let loginRepository: LoginRepositoryProtocol
    
    init(loginRepository: LoginRepositoryProtocol = LoginRepository()) {
        self.loginRepository = loginRepository
    }
    
    func login(loginData: LoginData) async throws -> AccessToken {
        try await loginRepository.login(loginData: loginData)
    }
    
    func bind(user: User) async throws -> AccessToken {
        try await loginRepository.bind(user: user)
    }
	
}
