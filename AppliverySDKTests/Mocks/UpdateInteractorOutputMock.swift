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
	var outDownloadDidEndCalled = false
	var outDownloadDidFail = (called: false, message: "")

	
	func downloadDidEnd() {
		self.outDownloadDidEndCalled = true
	}
	
	func downloadDidFail(message: String) {
		self.outDownloadDidFail = (true, message)
	}

}
