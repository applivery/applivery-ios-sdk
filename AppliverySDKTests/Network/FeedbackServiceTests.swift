//
//  FeedbackServiceTests.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez Agudo on 22/10/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import Applivery

class FeedbackServiceTests: XCTestCase {
	
	var feedbackService: FeedbackService!
	
	var appMock: AppMock!
	var deviceMock: DeviceMock!
	var configMock: GlobalConfig!
	
	override func setUp() {
		super.setUp()
		
		self.appMock = AppMock()
		self.deviceMock = DeviceMock()
		self.configMock = GlobalConfig()
		
		self.feedbackService = FeedbackService(
			app: self.appMock,
			device: self.deviceMock,
			config: self.configMock
		)
	}
	
	override func tearDown() {
		self.feedbackService = nil
		
		self.appMock = nil
		self.deviceMock = nil
		self.configMock = nil
		
		HTTPStubs.removeAllStubs()
		
		super.tearDown()
	}
	
	func test_not_nil() {
		XCTAssertNotNil(self.feedbackService)
	}
	
	// MARK: - Private Helpers
	
	private func setupConfigAndApp() {
		self.configMock.appId = "TEST_ID"
		self.appMock.stubBundleID = "TEST_BUNDLE_ID"
		self.appMock.stubVersion = "TEST_VERSION"
		self.appMock.stubVersionName = "TEST_VERSION_NAME"
	}
	
	private func setupDeviceWithBattery() {
		self.setupDeviceWithoutBattery()
		self.deviceMock.fakeBatteryLevel = 30
		self.deviceMock.fakeBatteryState = true
	}
	
	private func setupDeviceWithoutBattery() {
		self.deviceMock.fakeModel = "TEST MODEL"
		self.deviceMock.fakeType = "TEST TYPE"
		self.deviceMock.fakeSystemVersion = "TEST IOS VERSION"
		self.deviceMock.fakeVendorId = "test vendor"
		self.deviceMock.fakeBatteryLevel = 30
		self.deviceMock.fakeBatteryState = nil
		self.deviceMock.fakeNetworkType = "test network type"
		self.deviceMock.fakeResolution = "test resolution"
		self.deviceMock.fakeOrientation = "test orientation"
		self.deviceMock.fakeDiskFree = "test disk free"
		self.deviceMock.fakeRamUsed = "50"
		self.deviceMock.fakeRamTotal = "2000"
	}
	
	private func stubFeedbackOK() {
		_ = stub(condition: isPath("/api/feedback")) { _ in
			return StubResponse.stubResponse(with: "feedback_ok.json")
		}
	}
	
	private func stubFeedbackKO() {
		_ = stub(condition: isPath("/api/feedback")) { _ in
			return StubResponse.stubResponse(with: "ko.json")
		}
	}
}
