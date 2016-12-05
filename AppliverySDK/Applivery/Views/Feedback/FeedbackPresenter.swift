//
//  FeedbackPresenter.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 28/2/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


protocol FeedbackView {
	func showScreenshot(_ screenshot: UIImage?)
	func showFeedbackFormulary(with preview: UIImage)
	func showScreenshotPreview()
	func hideScreenshotPreview()
	func textMessage() -> String?
	func needMessage()
	func showMessage(_ message: String)
	func showLoading()
	func stopLoading()
	func editedScreenshot() -> UIImage?
}


class FeedbackPresenter {

	var view: FeedbackView!
	var feedbackInteractor: PFeedbackInteractor!
	var feedbackCoordinator: PFeedbackCoordinator!
	var screenshotInteractor: PScreenshotInteractor!

	private var feedbackType: FeedbackType = .bug
	private var message: String?
	private var screenshot: Screenshot?
	private var editedScreenshot: Screenshot?
	private var attachScreenshot = true


	// MARK - Public Methods

	func viewDidLoad() {
		self.screenshot = self.screenshotInteractor.getScreenshot()
		self.view.showScreenshot(self.screenshot!.image)
	}

	func userDidTapCloseButton() {
		self.feedbackCoordinator.closeFeedback()
	}

	func userDidTapAddFeedbackButton() {
		guard let editedScreenshot = self.view.editedScreenshot() else {
			return LogWarn("Could not get edited screenshot")
		}
		
		self.editedScreenshot = Screenshot(image: editedScreenshot)
		self.view.showFeedbackFormulary(with: editedScreenshot)
	}

	func userDidTapSendFeedbackButton() {
		guard let message = self.view.textMessage() else {
			self.view.needMessage(); return
		}

		let screenshot = self.attachScreenshot ? self.editedScreenshot : nil
		let feedback = Feedback(feedbackType: self.feedbackType, message: message, screenshot: screenshot)

		self.view.showLoading()

		self.feedbackInteractor.sendFeedback(feedback) { result in
			switch result {
			case .success:
				self.view.stopLoading()
				self.feedbackCoordinator.closeFeedback()

			case .error(let message):
				self.view.showMessage(message)
			}
		}
	}

	func userDidSelectedFeedbackType(_ type: FeedbackType) {
		self.feedbackType = type
	}

	func userDidChangedAttachScreenshot(attach: Bool) {
		self.attachScreenshot = attach

		if attach {
			self.view.showScreenshotPreview()
		} else {
			self.view.hideScreenshotPreview()
		}
	}
	
	func userDidTapPreview() {		
		self.view.showScreenshot(nil)
	}
}
