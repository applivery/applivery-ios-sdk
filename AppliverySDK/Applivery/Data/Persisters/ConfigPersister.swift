//
//  ConfigPersister.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 5/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation


protocol UserDefaults {
	func valueForKey(key: String) -> AnyObject?
}

extension NSUserDefaults: UserDefaults {}


class ConfigPersister: NSObject {
	
	private let kMinVersionKey			= "APPLIVERY_MIN_VERSION"
	private let kForceUpdateKey			= "APPLIVERY_FORCE_UPDATE"
	private let kLastBuildId			= "APPLIVERY_LAST_BUILD_ID"
	private let kForceUpdateMessageKey	= "APPLIVERY_FORCE_UPDATE_MESSAGE"
	private let kOtaUpdateKey			= "APPLIVERY_OTA_UPDATE_KEY"
	private let kLastBuildVersion		= "APPLIVERY_LAST_BUILD_VERSION"
	private let kOtaUpdateMessageKey	= "ApPLIVERY_OTA_UPDATE_MESSAGE"
	
	private var userDefaults: UserDefaults
	
	
	init(userDefaults: UserDefaults = NSUserDefaults.standardUserDefaults()) {
		self.userDefaults = userDefaults
	}
	
	
	// MARK - Initializers
	
	///  Get the current config stored on disk
	///  - returns: config object with the data stored. Could be nil if no previus data was saved
	func getConfig() -> Config? {
		let config = Config()
		
		guard
			let minVersion			= self.userDefaults.valueForKey(kMinVersionKey)		as? String,
			let forceUpdate			= self.userDefaults.valueForKey(kForceUpdateKey)	as? Bool,
			let lastBuildId			= self.userDefaults.valueForKey(kLastBuildId)		as? String,
			let otaUpdate			= self.userDefaults.valueForKey(kOtaUpdateKey)		as? Bool,
			let lastBuildVersion	= self.userDefaults.valueForKey(kLastBuildVersion)	as? String
			else { return nil }
		
		config.forceUpdate	= forceUpdate
		config.minVersion	= minVersion
		config.lastBuildId	= lastBuildId
		config.otaUpdate	= otaUpdate
		config.lastVersion	= lastBuildVersion
		config.forceUpdateMessage	= self.userDefaults.valueForKey(kForceUpdateMessageKey)	as? String
		config.otaUpdateMessage		= self.userDefaults.valueForKey(kOtaUpdateMessageKey)	as? String
		
		return config
	}
	
	func saveConfig(config: Config) {
		let userDefaults = NSUserDefaults.standardUserDefaults()
		
		userDefaults.setValue(config.minVersion,		 forKey: kMinVersionKey)
		userDefaults.setBool( config.forceUpdate,		 forKey: kForceUpdateKey)
		userDefaults.setValue(config.lastBuildId,		 forKey: kLastBuildId)
		userDefaults.setValue(config.forceUpdateMessage, forKey: kForceUpdateMessageKey)
		userDefaults.setBool(config.otaUpdate,			 forKey: kOtaUpdateKey)
		userDefaults.setValue(config.lastVersion,		 forKey: kLastBuildVersion)
		userDefaults.setValue(config.otaUpdateMessage,	 forKey: kOtaUpdateMessageKey)
		
		userDefaults.synchronize()
		
		LogInfo("Applivery configuration was updated")
	}
}
