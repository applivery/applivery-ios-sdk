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

	override func fetchConfig(_ completionHandler: @escaping (_ success: Bool, _ config: Config?, _ error: NSError?) -> Void) {
		completionHandler(self.success, self.config, self.error)
	}
}
