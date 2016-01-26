//
//  UpdateInteractoMock.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 8/12/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation
@testable import Applivery


class UpdateInteractoMock: PUpdateInteractor {
	
	var output: UpdateInteractorOutput! // NO NEEDED
	
	
	// INPUTS
	var inForceUpdateMessage: String!
	var inOtaUpdateMessage: String!
	
	// OUTPUTS
	var outDownloadLastBuildCalled = false
	
	
	func forceUpdateMessage() -> String {
		return self.inForceUpdateMessage
	}
	
	func otaUpdateMessage() -> String {
		return self.inOtaUpdateMessage
	}
	
	func downloadLastBuild() {
		self.outDownloadLastBuildCalled = true
	}
}
