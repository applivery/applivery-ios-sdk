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
	var outForceUpdateCalled = false
	var outOtaUpdateCalled = false
	var outFeedbackEventCalled = false


	func forceUpdate() {
		self.outForceUpdateCalled = true
	}

	func otaUpdate() {
		self.outOtaUpdateCalled = true
	}

	func feedbackEvent() {
		self.outFeedbackEventCalled = true
	}
}
