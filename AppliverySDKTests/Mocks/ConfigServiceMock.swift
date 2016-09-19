//
//  ConfigServiceMock.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 6/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import UIKit
@testable import Applivery

class ConfigServiceMock: ConfigService {
	
	var success: Bool!
	var config: Config!
	var error: NSError!
	
	override func fetchConfig(_ completionHandler: (_ success: Bool, _ config: Config?, _ error: NSError?) -> Void) {
		completionHandler(success: self.success, config: self.config, error: self.error)
	}
}
