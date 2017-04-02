//
//  Environments.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 27/2/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


class Environments {

	static let HostKey = "APPLIVERY_HOST"

	class func host() -> String? {
		guard let host = ProcessInfo.processInfo.environment["AppliveryHost"] else {
			if let host = self.readHost() {
				return host
			}

			return nil
		}

		self.writeHost(host)

		return host
	}


	fileprivate class func writeHost(_ host: String) {
		let userDefaults = Foundation.UserDefaults.standard
		userDefaults.setValue(host, forKey: Environments.HostKey)

		userDefaults.synchronize()
	}

	fileprivate class func readHost() -> String? {
		let userDefaults = Foundation.UserDefaults.standard
		let host = userDefaults.value(forKey: Environments.HostKey) as? String

		return host
	}
}
