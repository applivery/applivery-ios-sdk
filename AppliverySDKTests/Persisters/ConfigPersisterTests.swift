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

	
	// MARK - Get Config
	
	func test_getConfig_returnsNil_whenUserDefaultsIsEmpty() {
		let config = self.configPersister.getConfig()
		
		XCTAssert(config == nil)
	}

}
