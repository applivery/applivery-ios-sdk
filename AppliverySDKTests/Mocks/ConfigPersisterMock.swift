//
//  ConfigPersisterMock.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 5/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import UIKit
@testable import Applivery

class ConfigPersisterMock: ConfigPersister {
	
	// INPUT
	var config: Config?
	
	// OUTPUT
	var saveCalled = false
	
	override func getConfig() -> Config? {
		return self.config
	}
	
	override func saveConfig(config: Config) {
		self.saveCalled = true
	}
}
