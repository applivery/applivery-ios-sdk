//
//  FeedbackCoordinator.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 28/2/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


//protocol PFeedbackCoordinator {
//	func showFeedack()
//	func closeFeedback()
//}
//
//
//class FeedbackCoordinator: PFeedbackCoordinator {
//
//	var feedbackVC: FeedbackView!
//	fileprivate var app: AppProtocol
//	fileprivate var isFeedbackPresented = false
//	
//	// MARK: - Initializers
//	init(app: AppProtocol = App()) {
//		self.app = app
//	}
//
//
//	func showFeedack() {
//		guard !self.isFeedbackPresented else {
//			logWarn("Feedback view is already presented")
//			return
//		}
//		self.isFeedbackPresented = true
//
//		let feedbackVC = FeedbackVC.viewController()
//		self.feedbackVC = feedbackVC
//		feedbackVC.presenter = FeedbackPresenter(
//			view: self.feedbackVC,
//			feedbackInteractor: Configurator.feedbackInteractor(),
//			feedbackCoordinator: self,
//			screenshotInteractor: Configurator.screenshotInteractor()
//		)
//		
//		self.app.presentModal(feedbackVC, animated: false)
//	}
//
//	func closeFeedback() {
//		self.feedbackVC.dismiss(animated: true) {
//			self.isFeedbackPresented = false
//		}
//	}
//
//}
