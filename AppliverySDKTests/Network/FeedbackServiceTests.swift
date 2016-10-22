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
	var configMock: GlobalConfig!
	
	override func setUp() {
		super.setUp()
		
		self.appMock = AppMock()
		self.configMock = GlobalConfig()
		
		self.feedbackService = FeedbackService(
			app: self.appMock,
			config: self.configMock
		)
	}
	
	override func tearDown() {
		self.feedbackService = nil
		
		self.appMock = nil
		self.configMock = nil
		
		OHHTTPStubs.removeAllStubs()
		
		super.tearDown()
	}
	
	func test_not_nil() {
		XCTAssertNotNil(self.feedbackService)
	}
	
	func test_postFeedback_buildTheRequest() {
		self.stubFeedbackOK()
		
		self.configMock.appId = "TEST_ID"
		
		self.appMock.inBundleID = "TEST_BUNDLE_ID"
		self.appMock.inVersion = "TEST_VERSION"
		self.appMock.inVersionName = "TEST_VERSION_NAME"
		
		let feedback = Feedback(feedbackType: .Bug, message: "TEST_MESSAGE", screenshot: nil)
		
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
					"model": UIDevice.current.modelName,
					"vendor": "Apple",
					"type": UIDevice.current.model
					// id
					// battery
					// batteryStatus
					// network
					// resolution
					// ramFree
					// diskFree
					// orientation
				],
				"os": [
					"name": "iOS",
					"version": UIDevice.current.systemVersion
				]
			],
			"screenshot": ""
		]
		
		XCTAssert(self.feedbackService.request!.bodyParams == expectedBody)
		XCTAssert(self.feedbackService.request?.urlParams == [:])
		
		self.waitForExpectations(timeout: 1) { _ in }
	}
	
	
	
	
	// MARK: - Private Helpers
	
	private func stubFeedbackOK() {
		let _ = stub(condition: isPath("/api/feedback")) { request in
			return OHHTTPStubsResponse(
				fileAtPath: OHPathForFile("feedback_ok.json", type(of: self))!,
				statusCode: 200,
				headers: ["Content-Type":"application/json"]
			)
		}
	}
}
