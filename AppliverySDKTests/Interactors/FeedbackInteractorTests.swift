//
//  FeedbackInteractorTests.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 16/4/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import XCTest
@testable import Applivery


class FeedbackInteractorTests: XCTestCase {

	var feedbackInteractor: FeedbackInteractor!
	var feedbackServiceMock: FeedbackServiceMock!


    override func setUp() {
        super.setUp()

		self.feedbackServiceMock = FeedbackServiceMock()
		self.feedbackInteractor = FeedbackInteractor(service: self.feedbackServiceMock)
    }

    override func tearDown() {
        self.feedbackInteractor = nil
		self.feedbackServiceMock = nil

        super.tearDown()
    }

    func test_not_nil() {
        XCTAssertNotNil(self.feedbackInteractor)
    }


	func test_postFeedback_resultSuccess_whenServiceResultSuccess() {
		self.feedbackServiceMock.inResult = .success(true)
		let feedback = Feedback(
			feedbackType: .bug,
			message: "test message",
			screenshot: nil
		)

		var completionCalled = false
		self.feedbackInteractor.sendFeedback(feedback) { result in
			completionCalled = true

			XCTAssert(result == .success)
			XCTAssert(self.feedbackServiceMock.outPostFeedback.called == true)
			XCTAssert(self.feedbackServiceMock.outPostFeedback.feedback! == feedback)
		}

		XCTAssert(completionCalled == true)
	}


	func test_postFeedback_resultError_whenServiceResultError() {
		self.feedbackServiceMock.inResult = .error(NSError.appliveryError("error_test", code: -3))
		let feedback = Feedback(
			feedbackType: .bug,
			message: "test message",
			screenshot: nil
		)

		var completionCalled = false
		self.feedbackInteractor.sendFeedback(feedback) { result in
			completionCalled = true

			XCTAssert(result == .error("error_test"))
			XCTAssert(self.feedbackServiceMock.outPostFeedback.called == true)
			XCTAssert(self.feedbackServiceMock.outPostFeedback.feedback! == feedback)
		}

		XCTAssert(completionCalled == true)
	}

}


func == (left: FeedbackInteractorResult, right: FeedbackInteractorResult) -> Bool {
	switch (left, right) {
	case (.success, .success): return true
	case (.error(let messageLeft), .error(let messageRight)) where messageLeft == messageRight: return true
	default: return false
	}
}


func == (left: Feedback, right: Feedback) -> Bool {
	return left.feedbackType == right.feedbackType && left.message == right.message
}
