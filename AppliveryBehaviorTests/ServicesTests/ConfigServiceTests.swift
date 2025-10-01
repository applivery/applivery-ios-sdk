//
//  ConfigServiceTests.swift
//  Applivery
//
//  Created by Fran Alarza on 3/12/24.
//

import Testing
@testable import Applivery

struct ConfigServiceTests {
    let sut: ConfigService
    let client: MockAPIClient
    let appInfo: AppMock
    let configPersister: ConfigPersisterMock

    init() {
        self.client = MockAPIClient()
        self.appInfo = AppMock()
        self.configPersister = ConfigPersisterMock()

        self.sut = .init(
            client: client,
            appInfo: appInfo,
            configPersister: configPersister
        )
    }

    @Test
    func fetchConfigSuccess() async throws {
        // GIVEN
        let expectedConfig = ConfigMockData.config
        client.fetchHandler = { endpoint in
            #expect(endpoint.path == "/v1/app")
            return expectedConfig
        }

        // WHEN
        let config = try await sut.fetchConfig()

        // THEN
        #expect(config.status)
        #expect(!config.data.sdk.ios.forceAuth)
        #expect(!config.data.sdk.ios.forceUpdate)
    }

    @Test
    func getCurrentConfigSuccess() async throws {
        // GIVEN
        let expectedConfig = ConfigMockData.config
        configPersister.saveConfig(expectedConfig.data.sdk.ios)
        appInfo.stubVersion = "1.0.0"
        appInfo.stubBuildNumber = "50"

        // WHEN
        let currentConfig = sut.getCurrentConfig()

        // THEN
        #expect(currentConfig.version == "1.0.0")
        #expect(currentConfig.buildNumber == "50")
        #expect(!(currentConfig.config?.forceUpdate ?? false))
        #expect(currentConfig.config?.ota ?? false)
        #expect(currentConfig.config?.updateMsg == "Update available")
    }

    @Test
    func getUpdateConfigSuccess() async throws {
        // GIVEN
        let expectedConfig = ConfigMockData.config
        client.fetchHandler = { endpoint in
            #expect(endpoint.path == "/v1/app")
            return expectedConfig
        }
        configPersister.config = expectedConfig.data.sdk.ios
        appInfo.stubVersion = "1.0.0"
        appInfo.stubBuildNumber = "50"

        // WHEN
        let currentConfig = try await sut.updateConfig()

        // THEN
        #expect(currentConfig.version == "1.0.0")
        #expect(currentConfig.buildNumber == "50")
        #expect(!(currentConfig.config?.forceUpdate ?? false))
        #expect(currentConfig.config?.ota ?? false)
        #expect(currentConfig.config?.updateMsg == "Update available")
        #expect(configPersister.saveCalled)
        #expect(configPersister.config != nil)
    }
}
