//
//  ConfigService.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 6/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import UIKit

class ConfigService {

	func fetchConfig(_ completionHandler: @escaping (Bool, Config?, NSError?) -> Void) {
		let request = Request(
			endpoint: "/app/"
		)

		request.sendAsync { response in
			if response.success {
				do {
					let config = try response.body.map(Config.init(json:))
					completionHandler(response.success, config, nil)
				} catch {
					let error = NSError(
						domain: GlobalConfig.ErrorDomain,
						code: -1,
						userInfo: [GlobalConfig.AppliveryErrorKey: "Internal applivery error parsing json"])

					logError(error)
					completionHandler(false, nil, error)
				}
			} else {
				logError(response.error)
				completionHandler(response.success, nil, response.error)
			}
		}
	}

}
