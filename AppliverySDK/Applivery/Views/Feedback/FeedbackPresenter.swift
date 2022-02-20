//
//  FeedbackPresenter.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 28/2/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation
import UIKit

protocol FeedbackView {
	func showScreenshot(_ screenshot: UIImage?)
	func restoreSceenshot(_ screenshot: UIImage)
	func showFeedbackFormulary(with preview: UIImage)
	func showScreenshotPreview()
	func hideScreenshotPreview()
	func textMessage() -> String?
    func email() -> String?
	func needMessage()
	func showMessage(_ message: String)
	func showLoading()
	func stopLoading()
	func editedScreenshot() -> UIImage?
	func dismiss(animated flag: Bool, completion: (() -> Void)?)
}


enum FeedbackViewState {
	case preview
	case formulary
}


class FeedbackPresenter {

	let view: FeedbackView
	let feedbackInteractor: PFeedbackInteractor
	let feedbackCoordinator: PFeedbackCoordinator
	let screenshotInteractor: PScreenshotInteractor

	private var feedbackType: FeedbackType = .bug
	private var message: String?
	private var screenshot: Screenshot?
	private var editedScreenshot: Screenshot?
	private var attachScreenshot = true
	private var viewState: FeedbackViewState = .preview
	
	// MARK: - Initializers
	init(view: FeedbackView,
	     feedbackInteractor: PFeedbackInteractor,
	     feedbackCoordinator: PFeedbackCoordinator,
	     screenshotInteractor: PScreenshotInteractor) {
		self.view = view
		self.feedbackInteractor = feedbackInteractor
		self.feedbackCoordinator = feedbackCoordinator
		self.screenshotInteractor = screenshotInteractor
	}


	// MARK: - Public Methods

	func viewDidLoad() {
		self.screenshot = self.screenshotInteractor.getScreenshot()
		self.view.showScreenshot(self.screenshot?.image)
	}

	func userDidTapCloseButton() {
		self.feedbackCoordinator.closeFeedback()
	}

	func userDidTapAddFeedbackButton() {
		guard let editedScreenshot = self.view.editedScreenshot() else {
			return logWarn("Could not get edited screenshot")
		}

		self.editedScreenshot = Screenshot(image: editedScreenshot)
		self.view.showFeedbackFormulary(with: editedScreenshot)
		self.viewState = .formulary
	}

	func userDidTapSendFeedbackButton() {
		guard let message = self.view.textMessage() else {
			return self.view.needMessage()
		}
		let screenshot = self.attachScreenshot ? self.editedScreenshot : nil
        let feedback = Feedback(feedbackType: self.feedbackType, message: message, screenshot: screenshot, email: self.view.email())
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
		self.viewState = .preview
	}
	
	func userDidShake() {
		if let screenshot = self.screenshot?.image, self.viewState == .preview {
			self.view.restoreSceenshot(screenshot)
		}
	}
}
