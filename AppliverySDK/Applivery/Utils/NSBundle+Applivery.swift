//
//  NSBundle+Applivery.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 18/1/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation

extension Bundle {
	
	class func AppliveryBundle() -> Bundle {
		if let bundle = Bundle(identifier: "com.applivery.sdk") {
			return bundle
		}
		else {
			LogWarn("Applivery bundle not found")
			return Bundle.main
		}
	}
	
}
