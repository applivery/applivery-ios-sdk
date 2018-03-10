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
	
	func login(user: String, password: String, completion: () -> Void) {
		logWarn("Not implemented yet!")
		completion()
	}
	
}
