//
//  LoginRepositoryMock.swift
//  AppliverySDK
//
//  Created by Abigail Dominguez Morlans on 30/9/25.
//  Copyright © 2025 Applivery S.L. All rights reserved.
//

import Foundation
@testable import Applivery

class LoginRepositoryMock: LoginRepositoryProtocol {
    var shouldSucceed = false
    var shouldReturn401 = false
    func login(loginData: LoginData) async throws -> AccessToken {
        if shouldReturn401 { throw APIError.statusCode(401) }
        if shouldSucceed { return AccessToken(token: "token") }
        throw APIError.statusCode(500)
    }
    func bind(user: User) async throws -> CustomLogin { fatalError() }
    func getRedirctURL() async throws -> URL? { return URL(string: "https://applivery.com") }
    func unbindUser() {}
}
