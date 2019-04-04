//
//  LoginDataManager.swift
//  Applivery
//
//  Created by Alejandro Jiménez Agudo on 28/03/2019.
//  Copyright © 2019 Applivery S.L. All rights reserved.
//

import Foundation

struct LoginDataManager {
	
	let loginService: LoginService
	
	func login(user: String, password: String, result: @escaping (Result<AccessToken, NSError>) -> Void) {
		self.loginService.login(user: user, password: password, result: result)
	}
	
	func bind(user: User, result: @escaping (Result<AccessToken, NSError>) -> Void) {
		self.loginService.bind(user: user, result: result)
	}
	
}
