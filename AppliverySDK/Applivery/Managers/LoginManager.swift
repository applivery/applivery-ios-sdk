//
//  LoginManager.swift
//  Applivery
//
//  Created by Alejandro Jiménez Agudo on 12/3/18.
//  Copyright © 2018 Applivery S.L. All rights reserved.
//

import Foundation

struct LoginManager {
	
	private let loginInteractor = LoginInteractor(
		app: App(),
        loginService: LoginService(),
		globalConfig: GlobalConfig.shared,
		sessionPersister: SessionPersister(userDefaults: UserDefaults.standard)
	)
	
	func parse(error: NSError?, retry: @escaping () -> Void, next: @escaping () -> Void) {
		switch error?.code ?? 0 {
		case 401, 402, 4004:
			GlobalConfig.shared.accessToken = AccessToken(token: "")
			self.loginInteractor.showLogin(
				with: literal(.loginSessionExpired) ?? "<Login is required!>",
				loginHandler: retry,
				cancelHandler: next
			)
		default:
			next()
		}
	}
}
