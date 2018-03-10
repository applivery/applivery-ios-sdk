//
//  LoginInteractor.swift
//  Applivery
//
//  Created by Alejandro Jiménez Agudo on 9/3/18.
//  Copyright © 2018 Applivery S.L. All rights reserved.
//

import Foundation

struct LoginInteractor {
	
	var app: AppProtocol
	var loginService: LoginService
	
	func requestAuthorization(with config: Config, completion: @escaping () -> Void) {
		if config.authUpdate {
			logInfo("User authentication is required!")
			self.app.showLoginView(
				cancelHandler: completion,
				loginHandler: { self.login(user: $0, password: $1, completion: completion) }
			)
		} else {
			completion()
		}
	}
	
	func login(user: String, password: String, completion: @escaping () -> Void) {
		self.loginService.login(user: user, password: password) { result in
			switch result {
			case .success(let accessToken):
				logInfo("Fetched new access token: \(accessToken.token)")
				logInfo("Valid until \(accessToken.expirationDate)")
				completion()
				
			case .error(_):
				completion()
			}
		}
	}
	
}
