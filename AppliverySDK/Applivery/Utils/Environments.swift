//
//  Environments.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 27/2/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


class Environments {
	
	class func Host() -> String? {
		return NSProcessInfo.processInfo().environment["AppliveryHost"]
	}
	
}