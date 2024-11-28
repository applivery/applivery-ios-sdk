//
//  LoginInteractor.swift
//  Applivery
//
//  Created by Alejandro Jiménez Agudo on 9/3/18.
//  Copyright © 2018 Applivery S.L. All rights reserved.
//

import Foundation

final class LoginInteractor {
	
	let app: AppProtocol
    let loginDataManager: LoginDataManagerProtocol
	let globalConfig: GlobalConfig
	let sessionPersister: SessionPersister
    
    init(
        app: AppProtocol,
        loginDataManager: LoginDataManagerProtocol,
        globalConfig: GlobalConfig,
        sessionPersister: SessionPersister
    ) {
        self.app = app
        self.loginDataManager = loginDataManager
        self.globalConfig = globalConfig
        self.sessionPersister = sessionPersister
    }
	
	
    func requestAuthorization(with config: SDKData, loginHandler: @escaping () -> Void, cancelHandler: @escaping () -> Void) {
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
        Task {
            do {
                let accessToken = try await loginDataManager.bind(user: user)
                store(accessToken: accessToken, userName: user.email)
            } catch {
                logInfo("Error trying to bind a user \(error)")
            }
        }
	}
	
	func unbindUser() {
		logInfo("Unbinding user...")
		self.sessionPersister.save(accessToken: nil)
        self.sessionPersister.removeUser()
		self.globalConfig.accessToken = nil
	}
	
	// MARK: - Private Helpers
	private func login(user: String, password: String, loginHandler: @escaping () -> Void, cancelHandler: @escaping () -> Void) {
		self.globalConfig.accessToken = nil // Ensure to clean possibly previous access token
        Task {
            do {
                let accessToken = try await loginDataManager.login(loginData: .init(provider: "", payload: .init(user: user, password: password)))
                store(accessToken: accessToken, userName: user)
                loginHandler()
            } catch {
                self.showLogin(
                    with: literal(.loginInvalidCredentials) ?? "<Wrong credentials, try again>",
                    loginHandler: loginHandler,
                    cancelHandler: cancelHandler
                )
            }
            
        }
	}
	
    private func store(accessToken: AccessToken, userName: String) {
		logInfo("Fetched new access token: \(accessToken.token ?? "NO TOKEN")")
		self.sessionPersister.save(accessToken: accessToken)
        self.sessionPersister.saveUserName(userName: userName)
		self.globalConfig.accessToken = accessToken
	}
	
}
