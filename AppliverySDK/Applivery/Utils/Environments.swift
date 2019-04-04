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
	static let HostDownloadKey = "APPLIVERY_HOST_DOWNLOAD"

	class func host() -> String? {
		return self.host(with: self.HostKey)
	}
	
	class func hostDownload() -> String? {
		return self.host(with: self.HostDownloadKey)
	}
	
	
	// MARK: - Private Helpers
	
	private class func host(with key: String) -> String? {
		guard let host = ProcessInfo.processInfo.environment[key] else {
			if let host = self.readHost(from: key) {
				return host
			}
			
			return nil
		}
		
		self.write(host: host, to: key)
		
		return host
	}

	private class func write(host: String, to key: String) {
		let userDefaults = Foundation.UserDefaults.standard
		userDefaults.setValue(host, forKey: key)

		userDefaults.synchronize()
	}

	private class func readHost(from key: String) -> String? {
		let userDefaults = Foundation.UserDefaults.standard
		let host = userDefaults.value(forKey: key) as? String

		return host
	}
}
