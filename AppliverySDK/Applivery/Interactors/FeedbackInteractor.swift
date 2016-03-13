//
//  FeedbackInteractor.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 28/2/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


enum FeedbackInteractorResult {
	case Success
	case Error(String)
}

class FeedbackInteractor {
	
	private var service = FeedbackService()
	
	func sendFeedback(feedback: Feedback, completionHandler: FeedbackInteractorResult -> Void) {
		self.service.postFeedback(feedback) { result in
			switch result {
			case .Success:
				completionHandler(.Success)
				
			case .Error(let error):
				completionHandler(.Error(error.message()))
			}
		}
	}
	
}
