//
//  Environments.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 27/2/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


class Environments {

	static let HOST_KEY = "APPLIVERY_HOST"
	
	class func Host() -> String? {
		guard let host = NSProcessInfo.processInfo().environment["AppliveryHost"] else {
			if let host = self.readHost() {
				return host
			}
			
			return nil
		}
		
		self.writeHost(host)
		
		return host
	}
	
	
	private class func writeHost(host: String) {
		let userDefaults = NSUserDefaults.standardUserDefaults()
		userDefaults.setValue(host, forKey: Environments.HOST_KEY)
		
		userDefaults.synchronize()
	}
	
	private class func readHost() -> String? {
		let userDefaults = NSUserDefaults.standardUserDefaults()
		let host = userDefaults.valueForKey(Environments.HOST_KEY) as? String
		
		return host
	}
}