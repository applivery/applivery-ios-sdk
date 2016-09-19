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
		self.feedbackServiceMock.inResult = .success
		let feedback = Feedback(
			feedbackType: .Bug,
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
		self.feedbackServiceMock.inResult = .error(NSError.AppliveryError("error_test", code: -3))
		let feedback = Feedback(
			feedbackType: .Bug,
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


func ==(lhs: FeedbackInteractorResult, rhs: FeedbackInteractorResult) -> Bool {
	switch (lhs, rhs) {
	case (.success, .success): return true
	case (.error(let messageLeft), .error(let messageRight)) where messageLeft == messageRight: return true
	default: return false
	}
}


func ==(lhs: Feedback, rhs: Feedback) -> Bool {
	return lhs.feedbackType == rhs.feedbackType && lhs.message == rhs.message
}

