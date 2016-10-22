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

    override func setUp() {
        super.setUp()

		self.feedbackService = FeedbackService(
			app: App()
		)
    }

    override func tearDown() {
		self.feedbackService = nil

        super.tearDown()
    }

    func test_not_nil() {
        XCTAssertNotNil(self.feedbackService)
    }

}
