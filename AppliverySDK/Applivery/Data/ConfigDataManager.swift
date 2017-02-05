//
//  ConfigDataManager.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 4/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import UIKit


enum UpdateConfigResponse {
	case success(config: Config, version: String)
	case error
}

protocol PConfigDataManager {
	func getCurrentConfig() -> (config: Config?, version: String)
	func updateConfig(_ completionHandler: @escaping (_ response: UpdateConfigResponse) -> Void)
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

	func getCurrentConfig() -> (config: Config?, version: String) {
		let version = self.appInfo.getVersion()
		let config = self.configPersister.getConfig()

		return (config, version)
	}

	func updateConfig(_ completionHandler: @escaping (_ response: UpdateConfigResponse) -> Void) {
		self.configService.fetchConfig { success, config, error in
			if success && config != nil {
				let version = self.appInfo.getVersion()
				self.configPersister.saveConfig(config!)

				completionHandler(.success(config: config!, version: version))
			} else {
				LogError(error)
				completionHandler(.error)
			}
		}
	}

}
