//
//  NSError+Applivery.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 24/2/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


extension NSError {
	
	class func UnexpectedError() -> NSError {
		let error = NSError (
			domain: GlobalConfig.ErrorDomain,
			code: -1,
			userInfo: [
				GlobalConfig.AppliveryErrorKey: Localize("error_unexpected")
			]
		)
		
		return error
	}
	
}