//
//  FeedbackServiceTests.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez Agudo on 22/10/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import XCTest
@testable import Applivery

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
		
        super.tearDown()
    }

    func test_not_nil() {
        XCTAssertNotNil(self.feedbackService)
    }

//	func test_postFeedback_buildTheRequest() {
//		self.configMock.appId = "TEST_ID"
//		
//		self.appMock.inBundleID = "TEST_BUNDLE_ID"
//		self.appMock.inVersion = "TEST_VERSION"
//		self.appMock.inVersionName = "TEST_VERSION_NAME"
//		
//		let feedback = Feedback(feedbackType: .Bug, message: "TEST_MESSAGE", screenshot: nil)
//		
//		var completionCalled = false
//		self.feedbackService.postFeedback(feedback) { result in
//			completionCalled = true
//		}
//		
//		XCTAssert(completionCalled == true)
//	}
}
