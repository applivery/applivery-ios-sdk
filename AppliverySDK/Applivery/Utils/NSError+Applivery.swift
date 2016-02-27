//
//  NSError+Applivery.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 24/2/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


extension NSError {
	
	class func UnexpectedError(debugMessage: String? = nil, code: Int = -1) -> NSError {
		let error = AppliveryError(Localize("error_unexpected"), debugMessage: debugMessage, code: code)
		
		return error
	}
	
	class func AppliveryError(message: String? = nil, debugMessage: String? = nil, code: Int = -1) -> NSError {
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
}