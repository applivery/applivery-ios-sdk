//
//  LoginInteractor.swift
//  Applivery
//
//  Created by Alejandro Jiménez Agudo on 9/3/18.
//  Copyright © 2018 Applivery S.L. All rights reserved.
//

import Foundation

struct LoginInteractor {
	
	let app: AppProtocol
	let loginService: LoginService
	let globalConfig: GlobalConfig
	let sessionPersister: SessionPersister
	
	
	func requestAuthorization(with config: Config, loginHandler: @escaping () -> Void, cancelHandler: @escaping () -> Void) {
		self.globalConfig.accessToken = self.sessionPersister.loadAccessToken()
		if self.globalConfig.accessToken == nil {
			logInfo("User authentication is required!")
			self.showLogin(
				with: literal(.loginMessage) ?? "<Login is required!>",
				loginHandler: loginHandler,
				cancelHandler: cancelHandler
			)
		} else {
			loginHandler()
		}
	}
	
	func showLogin(with message: String, loginHandler: @escaping () -> Void, cancelHandler: @escaping () -> Void) {
		self.app.showLoginView(
			message: message,
			cancelHandler: cancelHandler,
			loginHandler: { self.login(user: $0, password: $1, loginHandler: loginHandler, cancelHandler: cancelHandler) }
		)
	}
	
	func bind(_ user: User) {
		self.loginService.bind(user: user) { result in
			switch result {
			case .success(let accessToken):
				logInfo("TOKEN: \(accessToken)")
			case .error:
				logInfo("Error trying to bind a user")
			}
		}
	}
	
	// MARK: - Private Helpers
	private func login(user: String, password: String, loginHandler: @escaping () -> Void, cancelHandler: @escaping () -> Void) {
		self.globalConfig.accessToken = nil // Ensure to clean possibly previous access token
		self.loginService.login(user: user, password: password) { result in
			switch result {
			case .success(let accessToken):
				logInfo("Fetched new access token: \(accessToken.token ?? "NO TOKEN")")
				self.sessionPersister.save(accessToken: accessToken)
				self.globalConfig.accessToken = accessToken
				loginHandler()

			case .error:
				self.showLogin(
					with: literal(.loginInvalidCredentials) ?? "<Wrong credentials, try again>",
					loginHandler: loginHandler,
					cancelHandler: cancelHandler
				)
			}
		}
	}
	
}
