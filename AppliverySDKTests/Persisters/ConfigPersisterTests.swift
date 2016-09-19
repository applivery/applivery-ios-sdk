//
//  ConfigPersisterTests.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 18/2/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import XCTest
@testable import Applivery


class ConfigPersisterTests: XCTestCase {
	
	var configPersister: ConfigPersister!
	var userDefaultsMock: UserDefaultsMock!
	

    override func setUp() {
        super.setUp()

		self.userDefaultsMock = UserDefaultsMock()
		self.configPersister = ConfigPersister(userDefaults: self.userDefaultsMock)
    }
	
    
    override func tearDown() {
		self.configPersister = nil
		self.userDefaultsMock = nil
		
        super.tearDown()
    }

    func test_notNil() {
		XCTAssertNotNil(self.configPersister)
    }

	
	// MARK - Get Config Tests
	
	func test_getConfig_returnsNil_whenUserDefaultsIsEmpty() {
		let config = self.configPersister.getConfig()
		
		XCTAssert(config == nil)
	}
	
	func test_getConfig_returnsNil_whenOnlyMinVersionIsMissed() {
		var dictionary = self.fullData()
		dictionary.removeValue(forKey: kMinVersionKey)
		
		self.userDefaultsMock.inDictionary = dictionary
		
		let config = self.configPersister.getConfig()
		
		XCTAssert(config == nil)
	}
	
	func test_getConfig_returnsNil_whenOnlyForceUpdateIsMissed() {
		var dictionary = self.fullData()
		dictionary.removeValue(forKey: kForceUpdateKey)
		
		self.userDefaultsMock.inDictionary = dictionary
		
		let config = self.configPersister.getConfig()
		
		XCTAssert(config == nil)
	}
	
	func test_getConfig_returnsNil_whenOnlyLasBuildIdIsMissed() {
		var dictionary = self.fullData()
		dictionary.removeValue(forKey: kLastBuildId)
		
		self.userDefaultsMock.inDictionary = dictionary
		
		let config = self.configPersister.getConfig()
		
		XCTAssert(config == nil)
	}
	
	func test_getConfig_returnsNil_whenOnlyOtaUpdateIsMissed() {
		var dictionary = self.fullData()
		dictionary.removeValue(forKey: kOtaUpdateKey)
		
		self.userDefaultsMock.inDictionary = dictionary
		
		let config = self.configPersister.getConfig()
		
		XCTAssert(config == nil)
	}
	
	func test_getConfig_returnsNil_whenOnlyLastBuildVersionIsMissed() {
		var dictionary = self.fullData()
		dictionary.removeValue(forKey: kLastBuildVersion)
		
		self.userDefaultsMock.inDictionary = dictionary
		
		let config = self.configPersister.getConfig()
		
		XCTAssert(config == nil)
	}
	
	func test_getConfig_returnsConfig_whenEveryFieldExists() {
		self.userDefaultsMock.inDictionary = self.fullData()
		
		let config = self.configPersister.getConfig()
		
		XCTAssert(config != nil)
		if config != nil {
			XCTAssert(config! == self.fullDataConfig())
		}
	}
	
	func test_getConfig_returnsConfig_whenEveryFieldExistsButOptionals() {
		var dictionary = self.fullData()
		dictionary.removeValue(forKey: kForceUpdateMessageKey)
		dictionary.removeValue(forKey: kOtaUpdateMessageKey)
		
		self.userDefaultsMock.inDictionary = dictionary
		
		let config = self.configPersister.getConfig()
		
		XCTAssert(config != nil)
		
		if config != nil {
			let expectedConfig = self.fullDataConfig()
			expectedConfig.forceUpdateMessage = nil
			expectedConfig.otaUpdateMessage = nil
			
			XCTAssert(config! == expectedConfig)
		}
	}

	
	// MARK - Save Config Tests
	
	func test_saveConfig_synchronizeSameDataAsConfigDataPassed() {
		let config = self.fullDataConfig()
		
		self.configPersister.saveConfig(config)
		
		XCTAssert(self.userDefaultsMock.outSyncedDictionary != nil)
		
		if self.userDefaultsMock.outSyncedDictionary != nil {
			let fullData = self.fullData()
			XCTAssert(self.userDefaultsMock.outSyncedDictionary! == fullData)
		}
	}
	
	
	// MARK - Helpers
	
	func fullDataConfig() -> Config {
		let config = Config()
		
		config.minVersion = "1.0"
		config.forceUpdate = true
		config.lastBuildId = "12e13d24f2"
		config.forceUpdateMessage = "test message"
		config.otaUpdate = true
		config.lastVersion = "1.0"
		config.otaUpdateMessage = "test message"
		
		return config
	}
	
	func fullData() -> [String: Any] {
		let config = self.fullDataConfig()
		
		let dictionary: [String: Any] =
		[
			kMinVersionKey: config.minVersion,
			kForceUpdateKey: config.forceUpdate,
			kLastBuildId: config.lastBuildId,
			kForceUpdateMessageKey: config.forceUpdateMessage ?? "",
			kOtaUpdateKey: config.otaUpdate,
			kLastBuildVersion: config.lastVersion,
			kOtaUpdateMessageKey: config.otaUpdateMessage ?? ""
		]
		
		return dictionary
	}
	
}

func ==(a: [String: Any], b: [String: Any]) -> Bool {
	return NSDictionary(dictionary: a).isEqual(to: b)
}
