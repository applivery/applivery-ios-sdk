//
//  FeedbackViewMock.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 21/4/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation
@testable import Applivery


class FeedbackViewMock: FeedbackView {

	// INPUTS
	var inMessage: String?
	
	
	// OUTPUTS
	var outShowScreenshot: (called: Bool, image: UIImage?) = (false, nil)
	var outShowFeedbackFormularyCalled = false
	var outShowScreenshotPreviewCalled = false
	var outHideScreenshotPreviewCalled = false
	var outNeedMessageCalled = false
	var outShowLoadingCalled = false
	var outStopLoadingCalled = false
	var outShowMessage: (called: Bool, message: String?) = (false, nil)
	
	
	// MARK - Methods
	
	func showScreenshot(screenshot: UIImage) {
		self.outShowScreenshot = (true, screenshot)
	}
	
	func showFeedbackFormulary() {
		self.outShowFeedbackFormularyCalled = true
	}
	
	func showScreenshotPreview() {
		self.outShowScreenshotPreviewCalled = true
	}
	
	func hideScreenshotPreview() {
		self.outHideScreenshotPreviewCalled = true
	}
	
	func textMessage() -> String? {
		return self.inMessage
	}
	
	func needMessage() {
		self.outNeedMessageCalled = true
	}
	
	func showMessage(message: String) {
		self.outShowMessage = (true, message)
	}
	
	func showLoading() {
		self.outShowLoadingCalled = true
	}
	
	func stopLoading() {
		self.outStopLoadingCalled = true
	}
	
}