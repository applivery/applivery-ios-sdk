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
		
		request.sendAsync { response in
			guard response.success, let json = response.body else {
				let error = response.error ?? NSError
					.unexpectedError(debugMessage: "unexpected error while fetching access token")
				logError(error)
				result(.error(error))
				return
			}
			
			let accessToken = AccessToken.parse(from: json)
			result(.success(accessToken))
		}
	}
	
}
