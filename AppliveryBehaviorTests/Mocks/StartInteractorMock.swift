//
//  StartInteractorMock.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 4/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import UIKit
@testable import Applivery

class StartInteractorMock: StartInteractor {

	var startCalled = false
	var outDisableFeedbackCalled = false

	override func start() {
		self.startCalled = true
	}

	override func disableFeedback() {
		self.outDisableFeedbackCalled = true
	}

}
