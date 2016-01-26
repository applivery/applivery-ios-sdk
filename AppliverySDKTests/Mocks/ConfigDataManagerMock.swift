//
//  ConfigDataManagerMock.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 4/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation
@testable import Applivery

class ConfigDataManagerMock: PConfigDataManager {
	
	// INPUTS
	var inVersion = ""
	var inCurrentConfig: Config?
	var inUpdateConfigResponse: UpdateConfigResponse!
	
	// OUTPUTS
	var outUpdateConfigCalled = false
	
	
	func getCurrentConfig() -> (config: Config?, version: String) {
		return (self.inCurrentConfig, self.inVersion)
	}
	
	func updateConfig(completionHandler: (response: UpdateConfigResponse) -> Void) {
		self.outUpdateConfigCalled = true
		completionHandler(response: self.inUpdateConfigResponse)
	}
	
}
