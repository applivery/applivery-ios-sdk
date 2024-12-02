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
let kOtaUpdateMessageKey	= "APPLIVERY_OTA_UPDATE_MESSAGE"
let kForceAuth				= "APPLIVERY_FORCE_AUTH"

protocol UserDefaultsProtocol {
	func value(forKey key: String) -> Any?
	func setValue(_ value: Any?, forKey key: String)
	func set(_ value: Bool, forKey key: String)
	func synchronize() -> Bool
	func set(_ value: AccessToken?, forKey key: String)
	func token(forKey key: String) -> AccessToken?
}

extension UserDefaults: UserDefaultsProtocol {}

class ConfigPersister: NSObject {

	fileprivate var userDefaults: UserDefaultsProtocol


	// MARK: - Initializers

	init(userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
		self.userDefaults = userDefaults
	}


	///  Get the current config stored on disk
	///  - returns: config object with the data stored. Could be nil if no previus data was saved
    func getConfig() -> SDKData? {
        
		guard
			let minVersion			= self.userDefaults.value(forKey: kMinVersionKey)		as? String,
			let forceUpdate			= self.userDefaults.value(forKey: kForceUpdateKey)		as? Bool,
			let lastBuildId			= self.userDefaults.value(forKey: kLastBuildId)			as? String,
			let otaUpdate			= self.userDefaults.value(forKey: kOtaUpdateKey)		as? Bool,
			let lastBuildVersion	= self.userDefaults.value(forKey: kLastBuildVersion)	as? String
			else { return nil }

        let sdkData = SDKData(
            minVersion: minVersion,
            forceUpdate: forceUpdate,
            lastBuildId: lastBuildId,
            mustUpdateMsg: self.userDefaults.value(forKey: kForceUpdateMessageKey)    as? String,
            ota: otaUpdate,
            lastBuildVersion: lastBuildVersion,
            updateMsg: self.userDefaults.value(forKey: kForceUpdateMessageKey) as? String,
            forceAuth: self.userDefaults.value(forKey: kForceAuth)                as? Bool ?? false
        )

		return sdkData
	}

    func saveConfig(_ config: SDKData) {
		self.userDefaults.setValue(config.minVersion as AnyObject?, forKey: kMinVersionKey)
		self.userDefaults.set(config.forceUpdate, forKey: kForceUpdateKey)
		self.userDefaults.setValue(config.lastBuildId as AnyObject?, forKey: kLastBuildId)
        self.userDefaults.setValue(config.mustUpdateMsg as AnyObject?, forKey: kForceUpdateMessageKey)
        self.userDefaults.set(config.ota, forKey: kOtaUpdateKey)
        self.userDefaults.setValue(config.lastBuildVersion as AnyObject?, forKey: kLastBuildVersion)
        self.userDefaults.setValue(config.updateMsg as AnyObject?, forKey: kOtaUpdateMessageKey)
		self.userDefaults.set(config.forceAuth, forKey: kForceAuth)

		if self.userDefaults.synchronize() {
			logInfo("Applivery configuration was updated")
		} else {
			logWarn("Couldn't syncronize Applivery configuration")
		}

	}
}
