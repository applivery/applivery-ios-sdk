//
//  ConfigPersister.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 5/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation


let kMinVersionKey			= "APPLIVERY_MIN_VERSION"
let kForceUpdateKey			= "APPLIVERY_FORCE_UPDATE"
let kLastBuildId			= "APPLIVERY_LAST_BUILD_ID"
let kForceUpdateMessageKey	= "APPLIVERY_FORCE_UPDATE_MESSAGE"
let kOtaUpdateKey			= "APPLIVERY_OTA_UPDATE_KEY"
let kLastBuildVersion		= "APPLIVERY_LAST_BUILD_VERSION"
let kOtaUpdateMessageKey	= "ApPLIVERY_OTA_UPDATE_MESSAGE"


protocol UserDefaults {
	func valueForKey(key: String) -> AnyObject?
	func setValue(value: AnyObject?, forKey key: String)
	func setBool(value: Bool, forKey key: String)
	func synchronize() -> Bool
}

extension NSUserDefaults: UserDefaults {}


class ConfigPersister: NSObject {
	
	private var userDefaults: UserDefaults
	
	
	// MARK - Initializers
	
	init(userDefaults: UserDefaults = NSUserDefaults.standardUserDefaults()) {
		self.userDefaults = userDefaults
	}
	
	
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
		self.userDefaults.setValue(config.minVersion,		 forKey: kMinVersionKey)
		self.userDefaults.setBool(config.forceUpdate,		 forKey: kForceUpdateKey)
		self.userDefaults.setValue(config.lastBuildId,		 forKey: kLastBuildId)
		self.userDefaults.setValue(config.forceUpdateMessage, forKey: kForceUpdateMessageKey)
		self.userDefaults.setBool(config.otaUpdate,			 forKey: kOtaUpdateKey)
		self.userDefaults.setValue(config.lastVersion,		 forKey: kLastBuildVersion)
		self.userDefaults.setValue(config.otaUpdateMessage,	 forKey: kOtaUpdateMessageKey)
		
		self.userDefaults.synchronize()
		
		LogInfo("Applivery configuration was updated")
	}
}
