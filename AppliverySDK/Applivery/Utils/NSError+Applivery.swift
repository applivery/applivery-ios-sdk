//
//  NSError+Applivery.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 24/2/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


extension NSError {

	class func UnexpectedError(debugMessage: String? = nil, code: Int = ErrorCodes.Unknown) -> NSError {
		let error = AppliveryError(Localize("error_unexpected"), debugMessage: debugMessage, code: code)

		return error
	}

	class func AppliveryError(_ message: String? = nil, debugMessage: String? = nil, code: Int = ErrorCodes.Unknown) -> NSError {
		var userInfo: [String: String] = [:]

		if message != nil {
			userInfo[GlobalConfig.AppliveryErrorKey] = message
		}

		if debugMessage != nil {
			userInfo[GlobalConfig.AppliveryErrorDebugKey] = debugMessage
		}

		let error = NSError (
			domain: GlobalConfig.ErrorDomain,
			code: code,
			userInfo: userInfo
		)

		return error
	}

	func message() -> String {
		guard let message = self.userInfo[GlobalConfig.AppliveryErrorKey] as? String else {
			return Localize("error_unexpected")
		}

		return message
	}
	
}
