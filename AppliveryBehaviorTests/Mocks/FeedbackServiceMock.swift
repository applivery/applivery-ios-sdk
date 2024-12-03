//
//  FeedbackServiceMock.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 16/4/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation
@testable import Applivery


class FeedbackServiceMock: FeedbackServiceProtocol {
    func postFeedback(_ feedback: Feedback) async throws {
        //
    }
    
    func postVideoFeedback(inputFeedback: Feedback) async throws {
        //
    }
    

//	// Inputs
//	var inResult: Result<Bool, NSError>!
//
//	// Outputs
//	var outPostFeedback: (called: Bool, feedback: Feedback?) = (false, nil)
//
//
//	func postFeedback(_ feedback: Feedback, completionHandler: @escaping (Result<Bool, NSError>) -> Void) {
//		self.outPostFeedback = (true, feedback)
//		completionHandler(self.inResult)
//	}

}
