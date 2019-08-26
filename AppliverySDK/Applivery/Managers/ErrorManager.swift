//
//  ErrorManager.swift
//  Applivery
//
//  Created by Alejandro Jiménez Agudo on 24/08/2019.
//  Copyright © 2019 Applivery S.L. All rights reserved.
//

import Foundation

struct ErrorManager {
	
	private let kUnexpectedErrorJson = "Unexpected error trying to parse Json"
	
	func error(from code: Int) -> NSError {
		let message = self.message(from: code)
		
		return NSError.appliveryError(message, code: code)
	}
	
	func error(from json: JSON?) -> NSError {
		let code = json?["code"]?.toInt() ?? -1
		let message = self.message(from: code)
		let debugMessage = json?["message"]?.toString() ?? self.kUnexpectedErrorJson
		
		return NSError.appliveryError(message, debugMessage: debugMessage, code: code)
	}
	
	
	// MARK: - Private Helpers
	
	private func message(from code: Int) -> String {
		switch code {
		case 401:
			return literal(.errorInvalidCredentials) ?? kLocaleErrorInvalidCredentials
		case 5004:
			return kLocaleErrorSubscriptionPlan
		default:
			return literal(.errorUnexpected) ?? kLocaleErrorUnexpected
		}
	}
	
}
