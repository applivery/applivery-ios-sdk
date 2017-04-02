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
	func closeFeedback()
}


class FeedbackCoordinator: PFeedbackCoordinator {

	fileprivate var feedbackVC: FeedbackVC!
	fileprivate var app: AppProtocol
	fileprivate var isFeedbackPresented = false
	
	// MARK - Initializers
	init(app: AppProtocol = App()) {
		self.app = app
	}


	func showFeedack() {
		guard !self.isFeedbackPresented else {
			logWarn("Feedback view is already presented")
			return
		}
		self.isFeedbackPresented = true

		self.feedbackVC = FeedbackVC.viewController()

		self.feedbackVC.presenter = FeedbackPresenter()
		self.feedbackVC.presenter.view = self.feedbackVC
		self.feedbackVC.presenter.feedbackInteractor = FeedbackInteractor(
			service: FeedbackService(
				app: App(),
				device: Device(),
				config: GlobalConfig.shared
			)
		)
		self.feedbackVC.presenter.screenshotInteractor = ScreenshotInteractor()
		self.feedbackVC.presenter.feedbackCoordinator = self

		self.app.presentModal(self.feedbackVC, animated: false)
	}

	func closeFeedback() {
		self.feedbackVC.dismiss(animated: true) {
			self.isFeedbackPresented = false
			self.destroyFeedback()
		}
	}

	fileprivate func destroyFeedback() {
		self.feedbackVC.presenter.view = nil
		self.feedbackVC.presenter.feedbackInteractor = nil
		self.feedbackVC.presenter.feedbackCoordinator = nil
		self.feedbackVC.presenter.screenshotInteractor = nil
		self.feedbackVC.presenter = nil
		self.feedbackVC = nil
	}

}
