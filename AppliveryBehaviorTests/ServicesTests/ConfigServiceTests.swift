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
    let appInfo: AppProtocol
    let configPersister: ConfigPersister
    
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

    @Test func fetchConfigSuccess() async throws {
        let expectedConfig = ConfigMockData.expectedConfig
        client.fetchHandler = { endpoint in
            #expect(endpoint.path == "/v1/app")
            return expectedConfig
        }
        let config = try await sut.fetchConfig()
        #expect(config.status)
        #expect(!config.data.sdk.ios.forceAuth)
        #expect(!config.data.sdk.ios.forceUpdate)
    }

}

struct ConfigMockData {
    
    static let expectedConfig = Config(
        status: true,
        data: ConfigData(
            sdk: SDK(
                ios: SDKData(
                    minVersion: "1.0",
                    forceUpdate: false,
                    lastBuildId: "build123",
                    mustUpdateMsg: nil,
                    ota: true,
                    lastBuildVersion: "1.0.1",
                    updateMsg: "Update available",
                    forceAuth: false
                )
            ),
            id: "configId",
            slug: "configSlug",
            oss: ["iOS"],
            name: "TestConfig",
            description: "This is a test config"
        )
    )
}
