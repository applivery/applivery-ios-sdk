//
//  ConfigDataManagerTests.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 5/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import XCTest
@testable import Applivery


class ConfigDataManagerTests: XCTestCase {
	
	var configDataManager: ConfigDataManager!
	var appMock: AppMock!
	var configPersisterMock: ConfigPersisterMock!
	var configServiceMock: ConfigServiceMock!
	
    override func setUp() {
        super.setUp()

		self.appMock = AppMock()
		self.configPersisterMock = ConfigPersisterMock()
		self.configServiceMock = ConfigServiceMock()
		
		self.configDataManager = ConfigDataManager(appInfo: self.appMock, configPersister: self.configPersisterMock, configService: configServiceMock)
    }
    
    override func tearDown() {
		self.configDataManager = nil
		
        super.tearDown()
    }
    
    func test_not_nil() {
		XCTAssertNotNil(self.configDataManager)
    }
	
	
	// MARK: CurrentConfig Tests
	
	func test_current_config_ok() {
		self.configPersisterMock.config = Config()
		self.configPersisterMock.config!.minVersion = "1.0.0"
		self.configPersisterMock.config!.forceUpdate = true
		self.appMock.inVersion = "2.0.0"
		
		let (config, version) = self.configDataManager.getCurrentConfig()
		
		XCTAssertTrue(config!.minVersion == "1.0.0")
		XCTAssertTrue(config!.forceUpdate == true)
		XCTAssertTrue(version == "2.0.0")
	}
	
	func test_current_config_no_stored() {
		self.appMock.inVersion = "2.0.0"
		
		let (config, version) = self.configDataManager.getCurrentConfig()
		
		XCTAssertNil(config)
		XCTAssertTrue(version == "2.0.0")
	}
	
	
	// MARK: UpdateConfig Tests
	
	func test_update_config_ok() {
		self.configServiceMock.success = true
		self.configServiceMock.config = Config()
		self.configServiceMock.config!.minVersion = "1.0.0"
		self.configServiceMock.config!.forceUpdate = true
		self.configServiceMock.config!.lastBuildId = ""
		self.configServiceMock.error = nil
		self.appMock.inVersion = "2.0.0"
		
		var closureCalled = false
		self.configDataManager.updateConfig { response in
			closureCalled = true
			
			XCTAssertTrue(self.configPersisterMock.saveCalled == true)
			
			let responseConfig = Config()
			responseConfig.forceUpdate = true
			responseConfig.minVersion = "1.0.0"
			responseConfig.lastBuildId = ""
			XCTAssert(response == .success(config: responseConfig, version: "2.0.0"))
		}
		
		XCTAssert(closureCalled == true)
	}
	
	func test_update_config_ok_but_nil() {
		self.configServiceMock.success = true
		self.configServiceMock.config = nil
		self.configServiceMock.error = nil
		self.appMock.inVersion = "2.0.0"
		
		var closureCalled = false
		self.configDataManager.updateConfig { response in
			closureCalled = true
			
			XCTAssertTrue(self.configPersisterMock.saveCalled == false)
			XCTAssert(response == .error)
		}
		
		XCTAssert(closureCalled == true)
	}
	
	func test_update_config_ko() {
		let error = NSError(domain: "applivery", code: -1, userInfo: nil)
		
		self.configServiceMock.success = false
		self.configServiceMock.config = nil
		self.configServiceMock.error = error
		self.appMock.inVersion = "2.0.0"
		
		var closureCalled = false
		self.configDataManager.updateConfig { response in
			closureCalled = true
			
			XCTAssertTrue(self.configPersisterMock.saveCalled == false)
			XCTAssert(response == .error)
		}
		
		XCTAssert(closureCalled == true)
	}
}


func ==(a: UpdateConfigResponse, b: UpdateConfigResponse) -> Bool {
	switch (a, b) {
		case (.success(let aConfig, let aVersion), .success(let bConfig, let bVersion))
			where aConfig == bConfig && aVersion == bVersion:
			return true
		
		case (.error, .error):
			return true
		
		default: return false
	}
}
