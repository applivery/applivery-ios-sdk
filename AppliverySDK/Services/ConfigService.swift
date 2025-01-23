//
//  ConfigService.swift
//  AppliverySDK
//
//  Created by Fran Alarza on 4/12/2024.
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
        let version = self.appInfo.getVersionName()
        let bundleVersion = self.appInfo.getVersion()
        let config = self.configPersister.getConfig()

        return UpdateConfigResponse(
            config: config,
            version: version,
            buildNumber: bundleVersion
        )
    }

    func updateConfig() async throws -> UpdateConfigResponse {
        let config = try await fetchConfig().data.sdk.ios
        let version = self.appInfo.getVersionName()
        let bundleVersion = self.appInfo.getVersion()
        self.configPersister.saveConfig(config)
        
        return UpdateConfigResponse(
            config: config,
            version: version,
            buildNumber: bundleVersion
        )
    }

}
