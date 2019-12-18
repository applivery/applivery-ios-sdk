//
//  ConfigDataManager.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 4/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation


struct UpdateConfigResponse: Equatable {
	let config: Config?
	let version: String
}


protocol PConfigDataManager {
	func getCurrentConfig() -> UpdateConfigResponse
	func updateConfig(_ completionHandler: @escaping (_ response: Result<UpdateConfigResponse, NSError>) -> Void)
}


class ConfigDataManager: PConfigDataManager {

	fileprivate let appInfo: AppProtocol
	fileprivate let configPersister: ConfigPersister
	fileprivate let configService: ConfigService


	// MARK: Initializers

	init(appInfo: AppProtocol, configPersister: ConfigPersister, configService: ConfigService) {
		self.appInfo = appInfo
		self.configPersister = configPersister
		self.configService = configService
	}


	convenience init() {
		let appInfo = App()
		let configPersister = ConfigPersister()
		let configService = ConfigService()

		self.init(appInfo: appInfo, configPersister: configPersister, configService: configService)
	}


	// MARK: Public methods

	func getCurrentConfig() -> UpdateConfigResponse {
		let version = self.appInfo.getVersion()
		let config = self.configPersister.getConfig()

		return UpdateConfigResponse(config: config, version: version)
	}

	func updateConfig(_ completionHandler: @escaping (_ response: Result<UpdateConfigResponse, NSError>) -> Void) {
		self.configService.fetchConfig { success, config, error in
			if let config = config, success {
				let version = self.appInfo.getVersion()
				self.configPersister.saveConfig(config)
				completionHandler(.success(UpdateConfigResponse(config: config, version: version)))
			
			} else {
				completionHandler(.error(error ?? NSError.unexpectedError()))
			}
		}
	}

}
