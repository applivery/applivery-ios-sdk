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


protocol UserDefaultsProtocol {
	func value(forKey key: String) -> Any?
	func setValue(_ value: Any?, forKey key: String)
	func set(_ value: Bool, forKey key: String)
	func synchronize() -> Bool
}

extension UserDefaults: UserDefaultsProtocol {}


class ConfigPersister: NSObject {
	
	fileprivate var userDefaults: UserDefaultsProtocol
	
	
	// MARK - Initializers
	
	init(userDefaults: UserDefaultsProtocol = Foundation.UserDefaults.standard) {
		self.userDefaults = userDefaults
	}
	
	
	///  Get the current config stored on disk
	///  - returns: config object with the data stored. Could be nil if no previus data was saved
	func getConfig() -> Config? {
		let config = Config()
		
		guard
			let minVersion			= self.userDefaults.value(forKey: kMinVersionKey)		as? String,
			let forceUpdate			= self.userDefaults.value(forKey: kForceUpdateKey)	as? Bool,
			let lastBuildId			= self.userDefaults.value(forKey: kLastBuildId)		as? String,
			let otaUpdate			= self.userDefaults.value(forKey: kOtaUpdateKey)		as? Bool,
			let lastBuildVersion	= self.userDefaults.value(forKey: kLastBuildVersion)	as? String
			else { return nil }
		
		config.forceUpdate	= forceUpdate
		config.minVersion	= minVersion
		config.lastBuildId	= lastBuildId
		config.otaUpdate	= otaUpdate
		config.lastVersion	= lastBuildVersion
		config.forceUpdateMessage	= self.userDefaults.value(forKey: kForceUpdateMessageKey)	as? String
		config.otaUpdateMessage		= self.userDefaults.value(forKey: kOtaUpdateMessageKey)	as? String
		
		return config
	}
	
	func saveConfig(_ config: Config) {
		self.userDefaults.setValue(config.minVersion as AnyObject?,		 forKey: kMinVersionKey)
		self.userDefaults.set(config.forceUpdate,		 forKey: kForceUpdateKey)
		self.userDefaults.setValue(config.lastBuildId as AnyObject?,		 forKey: kLastBuildId)
		self.userDefaults.setValue(config.forceUpdateMessage as AnyObject?, forKey: kForceUpdateMessageKey)
		self.userDefaults.set(config.otaUpdate,			 forKey: kOtaUpdateKey)
		self.userDefaults.setValue(config.lastVersion as AnyObject?,		 forKey: kLastBuildVersion)
		self.userDefaults.setValue(config.otaUpdateMessage as AnyObject?,	 forKey: kOtaUpdateMessageKey)
		
		if self.userDefaults.synchronize() {
			LogInfo("Applivery configuration was updated")
		} else {
			LogWarn("Couldn't syncronize Applivery configuration")
		}
		
	}
}
