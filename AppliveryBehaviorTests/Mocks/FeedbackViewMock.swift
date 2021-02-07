//
//  FeedbackViewMock.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 21/4/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation
import UIKit
@testable import Applivery


class FeedbackViewMock: FeedbackView {

	// INPUTS
	var fakeMessage: String?
	var fakeEditedScreenshot: UIImage?

	// OUTPUTS
	var spyShowScreenshot: (called: Bool, image: UIImage?) = (false, nil)
	var spyRestoreScreenshot: (called: Bool, image: UIImage?) = (false, nil)
	var spyShowFeedbackFormulary: (called: Bool, preview: UIImage?) = (false, nil)
	var spyShowScreenshotPreviewCalled = false
	var spyHideScreenshotPreviewCalled = false
	var spyNeedMessageCalled = false
	var spyShowLoadingCalled = false
	var spyStopLoadingCalled = false
	var spyShowMessage: (called: Bool, message: String?) = (false, nil)
	var spyDismissCalled = false


	// MARK: - Methods

	func showScreenshot(_ screenshot: UIImage?) {
		self.spyShowScreenshot = (true, screenshot)
	}
	
	func restoreSceenshot(_ screenshot: UIImage) {
		self.spyRestoreScreenshot = (true, screenshot)
	}

	func showFeedbackFormulary(with preview: UIImage) {
		self.spyShowFeedbackFormulary = (true, preview)
	}

	func showScreenshotPreview() {
		self.spyShowScreenshotPreviewCalled = true
	}

	func hideScreenshotPreview() {
		self.spyHideScreenshotPreviewCalled = true
	}

	func textMessage() -> String? {
		return self.fakeMessage
	}

	func needMessage() {
		self.spyNeedMessageCalled = true
	}

	func showMessage(_ message: String) {
		self.spyShowMessage = (true, message)
	}

	func showLoading() {
		self.spyShowLoadingCalled = true
	}

	func stopLoading() {
		self.spyStopLoadingCalled = true
	}
	
	func editedScreenshot() -> UIImage? {
		return self.fakeEditedScreenshot
	}
	
	func dismiss(animated flag: Bool, completion: (() -> Void)?) {
		self.spyDismissCalled = true
	}

}
