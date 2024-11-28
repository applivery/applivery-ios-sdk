//
//  ConfigDataManager.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 4/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation


struct UpdateConfigResponse {
    let config: SDKData?
	let version: String
}


protocol PConfigDataManager {
	func getCurrentConfig() -> UpdateConfigResponse
    func updateConfig() async throws -> UpdateConfigResponse
}


class ConfigDataManager: PConfigDataManager {

	fileprivate let appInfo: AppProtocol
	fileprivate let configPersister: ConfigPersister
	fileprivate let configService: ConfigService


	// MARK: Initializers

    init(
        appInfo: AppProtocol,
        configPersister: ConfigPersister,
        configService: ConfigService
    ) {
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

    func updateConfig() async throws -> UpdateConfigResponse {
        let config = try await self.configService.fetchConfig().data.sdk.ios
        let version = self.appInfo.getVersion()
        self.configPersister.saveConfig(config)
        return UpdateConfigResponse(config: config, version: version)
    }

}
