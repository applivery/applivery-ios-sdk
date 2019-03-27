//
//  LoginService.swift
//  Applivery
//
//  Created by Alejandro Jiménez Agudo on 10/3/18.
//  Copyright © 2018 Applivery S.L. All rights reserved.
//

import Foundation

struct LoginService {
	
	func login(user: String, password: String, result: @escaping (Result<AccessToken, NSError>) -> Void) {
		let request = Request(
			endpoint: "/v1/auth/login",
			method: "POST",
			bodyParams: [
				"provider": "traditional",
				"payload": [
					"user": user,
					"password": password				
				]
			]
		)
		
		self.doLogin(with: request, onCompletion: result)
	}
	
	func bind(user: User, result: @escaping (Result<AccessToken, NSError>) -> Void) {
		let request = Request(
			endpoint: "/v1/auth/customLogin",
			method: "POST",
			bodyParams: [
				"email": user.email,
				"firstName": user.firstName as Any,
				"lastName": user.lastName as Any,
				"tags": user.tags as Any
			]
		)
		
		self.doLogin(with: request, onCompletion: result)
	}
	
	// MARK: - Private Helpers
	
	private func doLogin(with request: Request, onCompletion result: @escaping (Result<AccessToken, NSError>) -> Void) {
		request.sendAsync { response in
			guard response.success else {
				let error = response.error ?? NSError.unexpectedError(debugMessage: "unexpected error while fetching access token")
				logError(error)
				result(.error(error))
				return
			}
			
			guard let accessToken = response.body.flatMap(AccessToken.parse) else {
				let error = NSError.unexpectedError(debugMessage: "No access token in the response object")
				logError(error)
				result(.error(error))
				return
			}
			
			result(.success(accessToken))
		}
	}
}
