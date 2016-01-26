//
//  NSBundle+Applivery.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 18/1/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation

extension NSBundle {
	
	class func AppliveryBundle() -> NSBundle {
		if let bundle = NSBundle(identifier: "com.applivery.sdk") {
			return bundle
		}
		else {
			LogWarn("Applivery bundle not found")
			return NSBundle.mainBundle()
		}
	}
	
}