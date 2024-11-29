//
//  ConfigService.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 6/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import UIKit

protocol ConfigServiceProtocol {
    func updateConfig() async throws -> UpdateConfigResponse
    func getCurrentConfig() -> UpdateConfigResponse
}

final class ConfigService: ConfigServiceProtocol {
    
    private let client: APIClientProtocol
    private let appInfo: AppProtocol
    private let configPersister: ConfigPersister
    
    init(
        client: APIClientProtocol = APIClient(),
        appInfo: AppProtocol = App(),
        configPersister: ConfigPersister = ConfigPersister()
    ) {
        self.client = client
        self.appInfo = appInfo
        self.configPersister = configPersister
    }
    
    func fetchConfig() async throws -> Config {
        let endpoint: AppliveryEndpoint = .config
        let config: Config = try await client.fetch(endpoint: endpoint)
        return config
    }
    
    func getCurrentConfig() -> UpdateConfigResponse {
        let version = self.appInfo.getVersion()
        let config = self.configPersister.getConfig()

        return UpdateConfigResponse(config: config, version: version)
    }

    func updateConfig() async throws -> UpdateConfigResponse {
        let config = try await fetchConfig().data.sdk.ios
        let version = self.appInfo.getVersion()
        self.configPersister.saveConfig(config)
        return UpdateConfigResponse(config: config, version: version)
    }

}
