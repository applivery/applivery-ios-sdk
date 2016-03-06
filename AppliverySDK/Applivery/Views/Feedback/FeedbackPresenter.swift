//
//  FeedbackPresenter.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 28/2/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


protocol FeedbackView {
	func showScreenshot(screenshot: UIImage)
	func showFeedbackFormulary()
	func showScreenshotPreview()
	func hideScreenshotPreview()
}


class FeedbackPresenter {
	
	var view: FeedbackView!
	var feedbackInteractor: FeedbackInteractor!
	var feedbackCoordinator: FeedbackCoordinator!

	private var screenshotInteractor = ScreenshotInteractor()
	
	
	func viewDidLoad() {
		let screenshot = self.screenshotInteractor.getScreenshot()
		self.view.showScreenshot(screenshot.image)
	}
	
	func userDidTapCloseButton() {
		self.feedbackCoordinator.closeFeedback()
	}
	
	func userDidTapSendFeedbackButton() {
		self.view.showFeedbackFormulary()
	}
	
	func userDidChangedAttachScreenshot(on: Bool) {
		if on {
			self.view.showScreenshotPreview()
		}
		else {
			self.view.hideScreenshotPreview()
		}
	}
}