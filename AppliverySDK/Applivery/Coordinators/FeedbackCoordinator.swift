//
//  FeedbackCoordinator.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 28/2/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


protocol PFeedbackCoordinator {
	func showFeedack()
}


class FeedbackCoordinator: PFeedbackCoordinator {

	private lazy var feedbackVC = FeedbackVC.viewController()
	private lazy var app = App()
	private var isFeedbackPresented = false
	
	
	func showFeedack() {
		guard !self.isFeedbackPresented else {
			LogWarn("Feedback view is already presented")
			return
		}
		
		self.isFeedbackPresented = true
		
		self.feedbackVC.presenter = FeedbackPresenter()
		self.feedbackVC.presenter.view = self.feedbackVC
		self.feedbackVC.presenter.feedbackInteractor = FeedbackInteractor()
		self.feedbackVC.presenter.feedbackCoordinator = self
		
		self.app.presentModal(self.feedbackVC)
	}
	
	func closeFeedback() {
		self.feedbackVC.dismissViewControllerAnimated(true) {
			self.isFeedbackPresented = false
		}
	}
	
}
