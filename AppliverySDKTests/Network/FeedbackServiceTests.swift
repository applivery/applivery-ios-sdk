//
//  FeedbackServiceTests.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez Agudo on 22/10/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import XCTest
@testable import Applivery
import OHHTTPStubs

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
		
		OHHTTPStubs.removeAllStubs()
		
		super.tearDown()
	}
	
	func test_not_nil() {
		XCTAssertNotNil(self.feedbackService)
	}
	
	func test_postFeedback_buildTheRequest() {
		self.stubFeedbackOK()
		self.setupConfigAndApp()
		self.setupDeviceWithBattery()
		
		let feedback = Feedback(feedbackType: .bug, message: "TEST_MESSAGE", screenshot: nil)
		
		let completionCalled = self.expectation(description: "completion called")
		self.feedbackService.postFeedback(feedback) { result in
			completionCalled.fulfill()
		}
		
		XCTAssert(self.feedbackService.request?.endpoint == "/api/feedback")
		XCTAssert(self.feedbackService.request?.method == "POST")
		
		let expectedBody: [String: Any] = [
			"app": "TEST_ID",
			"type": "bug",
			"message": "TEST_MESSAGE",
			"packageInfo": [
				"name": "TEST_BUNDLE_ID",
				"version": "TEST_VERSION",
				"versionName": "TEST_VERSION_NAME"
			],
			"deviceInfo": [
				"device": [
					"model": "TEST MODEL",
					"vendor": "Apple",
					"type": "TEST TYPE",
					"id": "test vendor",
					"network": "test network type",
					"resolution": "test resolution",
					"ramFree": "test ram free",
					"diskFree": "test disk free",
					"orientation": "test orientation",
					 "battery": 30,
					 "batteryStatus": true,
				],
				"os": [
					"name": "iOS",
					"version": "TEST IOS VERSION"
				]
			],
			"screenshot": ""
		]
		
		XCTAssert(self.feedbackService.request!.bodyParams == expectedBody)
		XCTAssert(self.feedbackService.request?.urlParams == [:])
		
		self.waitForExpectations(timeout: 1) { _ in }
	}
	
	func test_postFeedback_buildTheRequest_withoutBattery() {
		self.stubFeedbackOK()
		self.setupConfigAndApp()
		self.setupDeviceWithoutBattery()
		
		let feedback = Feedback(feedbackType: .bug, message: "TEST_MESSAGE", screenshot: nil)
		
		let completionCalled = self.expectation(description: "completion called")
		self.feedbackService.postFeedback(feedback) { result in
			completionCalled.fulfill()
		}
		
		XCTAssert(self.feedbackService.request?.endpoint == "/api/feedback")
		XCTAssert(self.feedbackService.request?.method == "POST")
		
		let expectedBody: [String: Any] = [
			"app": "TEST_ID",
			"type": "bug",
			"message": "TEST_MESSAGE",
			"packageInfo": [
				"name": "TEST_BUNDLE_ID",
				"version": "TEST_VERSION",
				"versionName": "TEST_VERSION_NAME"
			],
			"deviceInfo": [
				"device": [
					"model": "TEST MODEL",
					"vendor": "Apple",
					"type": "TEST TYPE",
					"id": "test vendor",
					"network": "test network type",
					"resolution": "test resolution",
					"ramFree": "test ram free",
					"diskFree": "test disk free",
					"orientation": "test orientation"
				],
				"os": [
					"name": "iOS",
					"version": "TEST IOS VERSION"
				]
			],
			"screenshot": ""
		]
		
		XCTAssert(self.feedbackService.request!.bodyParams == expectedBody)
		XCTAssert(self.feedbackService.request?.urlParams == [:])
		
		self.waitForExpectations(timeout: 1) { _ in }
	}
	
	func test_postFeedback_resultSuccess_whenJSONisOK() {
		self.stubFeedbackOK()
		self.setupConfigAndApp()
		self.setupDeviceWithBattery()
		
		let feedback = Feedback(feedbackType: .bug, message: "TEST_MESSAGE", screenshot: nil)
		
		let completionCalled = self.expectation(description: "completion called")
		self.feedbackService.postFeedback(feedback) { result in
			XCTAssert(result == Result.success(true))
			
			completionCalled.fulfill()
		}
		
		self.waitForExpectations(timeout: 1) { _ in }
	}
	
	func test_postFeedback_resultUnexpectedError_whenJSONisKO() {
		self.stubFeedbackKO()
		self.setupConfigAndApp()
		self.setupDeviceWithBattery()
		
		let feedback = Feedback(feedbackType: .bug, message: "TEST_MESSAGE", screenshot: nil)
		
		let completionCalled = self.expectation(description: "completion called")
		self.feedbackService.postFeedback(feedback) { result in
			XCTAssert(result == Result.error(NSError.UnexpectedError()))
			
			completionCalled.fulfill()
		}
		
		self.waitForExpectations(timeout: 1) { _ in }
	}
	
	
	// MARK: - Private Helpers
	
	private func setupConfigAndApp() {
		self.configMock.appId = "TEST_ID"
		self.appMock.inBundleID = "TEST_BUNDLE_ID"
		self.appMock.inVersion = "TEST_VERSION"
		self.appMock.inVersionName = "TEST_VERSION_NAME"
	}
	
	private func setupDeviceWithBattery() {
		self.setupDeviceWithoutBattery()
		self.deviceMock.inBatteryLevel = 30
		self.deviceMock.inBatteryState = true
	}
	
	private func setupDeviceWithoutBattery() {
		self.deviceMock.inModel = "TEST MODEL"
		self.deviceMock.inType = "TEST TYPE"
		self.deviceMock.inSystemVersion = "TEST IOS VERSION"
		self.deviceMock.inVendorId = "test vendor"
		self.deviceMock.inBatteryLevel = 30
		self.deviceMock.inBatteryState = nil
		self.deviceMock.inNetworkType = "test network type"
		self.deviceMock.inResolution = "test resolution"
		self.deviceMock.inOrientation = "test orientation"
		self.deviceMock.inRamFree = "test ram free"
		self.deviceMock.inDiskFree = "test disk free"
	}
	
	private func stubResponse(with json: String) -> OHHTTPStubsResponse {
		return OHHTTPStubsResponse(
			fileAtPath: OHPathForFile(json, type(of: self))!,
			statusCode: 200,
			headers: ["Content-Type":"application/json"]
		)
	}
	
	private func stubFeedbackOK() {
		let _ = stub(condition: isPath("/api/feedback")) { request in
			return self.stubResponse(with: "feedback_ok.json")
		}
	}
	
	private func stubFeedbackKO() {
		let _ = stub(condition: isPath("/api/feedback")) { request in
			return self.stubResponse(with: "ko.json")
		}
	}
}
