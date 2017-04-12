//
//  UpdateViewMock.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 8/12/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation
@testable import Applivery


class UpdateViewMock: UpdateView {

	// OUTPUTS
	var spyShowUpdateMessage = (called: false, message: "")
	var spyShowLoadingCalled = false
	var spyStopLoadingCalled = false
	var spyShowErrorMessage = (called: false, message: "")


	func showUpdateMessage(_ message: String) {
		self.spyShowUpdateMessage = (true, message)
	}

	func showLoading() {
		self.spyShowLoadingCalled = true
	}

	func stopLoading() {
		self.spyStopLoadingCalled = true
	}

	func showErrorMessage(_ message: String) {
		self.spyShowErrorMessage = (true, message)
	}

}
