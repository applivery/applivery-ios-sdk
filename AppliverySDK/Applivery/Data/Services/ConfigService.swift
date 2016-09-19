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
		let request = Request()
		request.endpoint = "/api/apps/" + GlobalConfig.shared.appId
		
		request.sendAsync {
			response in
			
			if response.success {
				do {
					let config = try Config(json: response.body!)
					completionHandler(response.success, config, nil)
				}
				catch {
					let error = NSError(
						domain: GlobalConfig.ErrorDomain,
						code: -1,
						userInfo: [GlobalConfig.AppliveryErrorKey: "Internal applivery error parsing json"])
					
					LogError(error)
					completionHandler(false, nil, error)
				}
			}
			else {
				LogError(response.error)
				completionHandler(response.success, nil, response.error)
			}
		}
	}
}



