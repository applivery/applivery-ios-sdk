//
//  FeedbackInteractor.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 28/2/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


enum FeedbackInteractorResult {
	case success
	case error(String)
}


protocol PFeedbackInteractor {
	func sendFeedback(_ feedback: Feedback, completionHandler: @escaping (FeedbackInteractorResult) -> Void)
}

class FeedbackInteractor: PFeedbackInteractor {

	fileprivate var service: PFeedbackService


	init(service: PFeedbackService = FeedbackService()) {
		self.service = service
	}

	func sendFeedback(_ feedback: Feedback, completionHandler: @escaping (FeedbackInteractorResult) -> Void) {
		self.service.postFeedback(feedback) { result in
			switch result {
			case .success:
				completionHandler(.success)

			case .error(let error):
				completionHandler(.error(error.message()))
			}
		}
	}

}
