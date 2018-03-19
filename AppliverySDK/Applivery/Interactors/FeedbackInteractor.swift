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

struct FeedbackInteractor: PFeedbackInteractor {

	let service: PFeedbackService
	let configDataManager: PConfigDataManager
	let loginInteractor: LoginInteractor

	func sendFeedback(_ feedback: Feedback, completionHandler: @escaping (FeedbackInteractorResult) -> Void) {
		let config = self.configDataManager.getCurrentConfig().config ?? Config()
		if config.authFeedback {
			self.loginInteractor.requestAuthorization(
				with: config,
				loginHandler: { self.send(feedback: feedback, completion: completionHandler) },
				cancelHandler: { completionHandler(.error(literal(.loginMessage) ?? "<Need authentication>")) }
			)
		} else {
			self.send(feedback: feedback, completion: completionHandler)
		}
	}
	
	// MARK: - Private Helpers
	private func send(feedback: Feedback, completion: @escaping (FeedbackInteractorResult) -> Void) {
		self.service.postFeedback(feedback) { result in
			switch result {
			case .success:
				completion(.success)
				
			case .error(let error):
				completion(.error(error.message()))
			}
		}
	}

}
