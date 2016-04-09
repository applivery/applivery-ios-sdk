//
//  AppliverySDKTests.swift
//  AppliverySDKTests
//
//  Created by Alejandro Jiménez on 3/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import XCTest
@testable import Applivery

class AppliveryTests: XCTestCase {
	
	var applivery: Applivery!
	var startInteractorMock: StartInteractorMock!
	var globalConfigMock: GlobalConfig!
	var updateCoordinatorMock: UpdateCoordinatorMock!
	var feedbackCoordinatorMock: FeedbackCoordinatorMock!
	
	
    override func setUp() {
        super.setUp()
		
		self.globalConfigMock = GlobalConfig()
		self.startInteractorMock = StartInteractorMock()
		self.updateCoordinatorMock = UpdateCoordinatorMock()
		self.feedbackCoordinatorMock = FeedbackCoordinatorMock()
		
		self.applivery = Applivery(
			startInteractor: self.startInteractorMock,
			globalConfig: globalConfigMock,
			updateCoordinator: self.updateCoordinatorMock,
			feedbackCoordinator: self.feedbackCoordinatorMock
		)
    }
    
    override func tearDown() {
		self.feedbackCoordinatorMock = nil
		self.globalConfigMock = nil
		self.startInteractorMock = nil
		self.updateCoordinatorMock = nil
		self.applivery = nil
		
        super.tearDown()
    }
	
    func test_not_nil() {
		XCTAssertNotNil(self.applivery)
    }
	
	
	// MARK - Start
	func test_start() {
		self.applivery.start(apiKey: "test_api_key", appId: "test_app_id", appStoreRelease: false)
		
		XCTAssert(self.globalConfigMock.apiKey == "test_api_key")
		XCTAssert(self.globalConfigMock.appId == "test_app_id")
		XCTAssert(self.globalConfigMock.appStoreRelease == false)
		
		XCTAssert(self.startInteractorMock.startCalled == true)
	}
	
	func test_startWithStoreRelease() {
		self.applivery.start(apiKey: "test_api_key", appId: "test_app_id", appStoreRelease: true)
		
		XCTAssert(self.globalConfigMock.apiKey == "test_api_key")
		XCTAssert(self.globalConfigMock.appId == "test_app_id")
		XCTAssert(self.globalConfigMock.appStoreRelease == true)
		
		XCTAssert(self.startInteractorMock.startCalled == true)
	}
	
	
	// MARK - Force Update
	func test_force_update() {
		self.applivery.forceUpdate()
		
		XCTAssert(self.updateCoordinatorMock.outForceUpdateCalled == true)
	}
	
	
	// MARK - Force Update
	func test_ota_update() {
		self.applivery.otaUpdate()
		
		XCTAssert(self.updateCoordinatorMock.outOtaUpdateCalled == true)
	}
	
	// MARK - Show Feedback
	func test_showFeedback() {
		self.applivery.feedbackEvent()
		
		XCTAssert(self.feedbackCoordinatorMock.outShowFeedbackCalled == true)
	}
	
}
