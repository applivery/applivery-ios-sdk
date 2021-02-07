//
//  UpdateInteractorOutputMock.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 7/1/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation
@testable import Applivery

class UpdateInteractorOutputMock: UpdateInteractorOutput {

	// Outputs
	var spyDownloadDidEndCalled = false
	var spyDownloadDidFail = (called: false, message: "")

	// MARK: - Public Methods
	func downloadDidEnd() {
		self.spyDownloadDidEndCalled = true
	}

	func downloadDidFail(_ message: String) {
		self.spyDownloadDidFail = (true, message)
	}
	
	func showLogin() {
		
	}

}
