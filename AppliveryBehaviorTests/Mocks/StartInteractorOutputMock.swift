//
//  StartInteractorOutputMock.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 4/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation
@testable import Applivery

class StartInteractorOutputMock: StartInteractorOutput {

	// OUTPUTS
	var spyForceUpdateCalled = false
	var spyOtaUpdateCalled = false
	var spyFeedbackEventCalled = false
	var spyCredentialError: (called: Bool, message: String?) = (false, nil)

	func forceUpdate() {
		self.spyForceUpdateCalled = true
	}

	func otaUpdate() {
		self.spyOtaUpdateCalled = true
	}

	func feedbackEvent() {
		self.spyFeedbackEventCalled = true
	}
	
	func credentialError(message: String) {
		self.spyCredentialError = (true, message)
	}
}
