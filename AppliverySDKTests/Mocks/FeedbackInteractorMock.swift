//
//  FeedbackInteractorMock.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 22/4/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation
@testable import Applivery


class FeedbackInteractorMock: PFeedbackInteractor {

	var inResult: FeedbackInteractorResult!
	var outSendFeedback: (called: Bool, feedback: Feedback?) = (false, nil)


	func sendFeedback(_ feedback: Feedback, completionHandler: @escaping (FeedbackInteractorResult) -> Void) {
		self.outSendFeedback = (true, feedback)
		completionHandler(self.inResult)
	}

}
