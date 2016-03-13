//
//  FeedbackInteractor.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 28/2/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


class FeedbackInteractor {
	
	private var service = FeedbackService()
	
	func sendFeedback(feedback: Feedback) {
		self.service.postFeedback(feedback) { result in
			switch result {
			case .Success:
				LogInfo("Success")
				
			case .Error(let error):
				LogError(error)
			}
		}
	}
	
}
