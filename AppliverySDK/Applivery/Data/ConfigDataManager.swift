//
//  ConfigDataManager.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 4/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import UIKit


enum UpdateConfigResponse {
	case Success(config: Config, version: String)
	case Error
}

protocol PConfigDataManager {
	func getCurrentConfig() -> (config: Config?, version: String)
	func updateConfig(completionHandler: (response: UpdateConfigResponse) -> Void)
}


class ConfigDataManager: PConfigDataManager {
	
	private let appInfo: PApp
	private let configPersister: ConfigPersister
	private let configService: ConfigService
	
	
	// MARK: Initializers
	
	init(appInfo: PApp, configPersister: ConfigPersister, configService: ConfigService) {
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
	
	func updateConfig(completionHandler: (response: UpdateConfigResponse) -> Void) {
		self.configService.fetchConfig {
			success, config, error in
			
			if success && config != nil {
				let version = self.appInfo.getVersion()
				self.configPersister.saveConfig(config!)
				
				completionHandler(response: .Success(config: config!, version: version))
			}
			else {
				LogError(error)
				completionHandler(response: .Error)
			}
		}
	}

}
