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
		self.feedbackServiceMock.inResult = .Success
		let feedback = Feedback(
			feedbackType: .Bug,
			message: "test message",
			screenshot: nil
		)
		
		var completionCalled = false
		self.feedbackInteractor.sendFeedback(feedback) { result in
			completionCalled = true
			
			XCTAssert(result == .Success)
			XCTAssert(self.feedbackServiceMock.outPostFeedback.called == true)
			XCTAssert(self.feedbackServiceMock.outPostFeedback.feedback! == feedback)
		}
		
		XCTAssert(completionCalled == true)
	}
	
	
	func test_postFeedback_resultError_whenServiceResultError() {
		self.feedbackServiceMock.inResult = .Error(NSError.AppliveryError("error_test", code: -3))
		let feedback = Feedback(
			feedbackType: .Bug,
			message: "test message",
			screenshot: nil
		)
		
		var completionCalled = false
		self.feedbackInteractor.sendFeedback(feedback) { result in
			completionCalled = true
			
			XCTAssert(result == .Error("error_test"))
			XCTAssert(self.feedbackServiceMock.outPostFeedback.called == true)
			XCTAssert(self.feedbackServiceMock.outPostFeedback.feedback! == feedback)
		}
		
		XCTAssert(completionCalled == true)
	}
	
}


func ==(lhs: FeedbackInteractorResult, rhs: FeedbackInteractorResult) -> Bool {
	switch (lhs, rhs) {
	case (.Success, .Success): return true
	case (.Error(let messageLeft), .Error(let messageRight)) where messageLeft == messageRight: return true
	default: return false
	}
}


func ==(lhs: Feedback, rhs: Feedback) -> Bool {
	return lhs.feedbackType == rhs.feedbackType && lhs.message == rhs.message
}

