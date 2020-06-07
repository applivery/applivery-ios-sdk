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
		let code = json?["error.code"]?.toInt() ?? -1
		let message = self.message(from: code, with: json?["error.data"])
		let debugMessage = json?["error.message"]?.toString() ?? self.kUnexpectedErrorJson
		
		return NSError.appliveryError(message, debugMessage: debugMessage, code: code)
	}
	
	
	// MARK: - Private Helpers
	
	private func message(from code: Int, with json: JSON? = nil) -> String {
		switch code {
		case 401:
			return literal(.errorInvalidCredentials) ?? kLocaleErrorInvalidCredentials
		case 5004:
			return kLocaleErrorSubscriptionPlan
		case 5003:
			guard let limit = json?["limit"]?.toInt() else {
				return kLocaleErrorDownloadLimit
			}
			return kLocaleErrorDownloadLimitMonth.replacingOccurrences(of: "%s", with: String(limit))
		default:
			return literal(.errorUnexpected) ?? kLocaleErrorUnexpected
		}
	}
	
}
