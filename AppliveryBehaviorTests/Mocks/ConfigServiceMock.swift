//
//  ConfigServiceMock.swift
//  Applivery
//
//  Created by Fran Alarza on 5/12/24.
//

import Foundation
@testable import Applivery

final class ConfigServiceMock: ConfigServiceProtocol {
    var updateConfigResponse: UpdateConfigResponse?
    var currentConfigResponse: UpdateConfigResponse?

    func updateConfig() async throws -> UpdateConfigResponse {
        if let response = updateConfigResponse {
            return response
        } else {
            throw NSError(domain: "MockConfigServiceError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No response configured for updateConfig"])
        }
    }

    func getCurrentConfig() -> UpdateConfigResponse {
        if let response = currentConfigResponse {
            return response
        }
        fatalError("No response configured for getCurrentConfig")
    }

    func fetchConfig() async throws -> Applivery.Config {
        if let response = currentConfigResponse {
            // Build a minimal Config from the UpdateConfigResponse mock
            let sdkData = response.config ?? SDKData(
                minVersion: nil,
                forceUpdate: false,
                lastBuildId: nil,
                mustUpdateMsg: nil,
                ota: false,
                lastBuildVersion: nil,
                updateMsg: nil,
                forceAuth: false
            )
            let sdk = SDK(ios: sdkData)
            let configData = ConfigData(
                sdk: sdk,
                id: response.version,
                slug: "mock-slug",
                oss: [],
                name: "mock-name",
                description: "mock-description"
            )
            return Config(status: true, data: configData)
        } else {
            throw NSError(domain: "MockConfigServiceError", code: 2, userInfo: [NSLocalizedDescriptionKey: "No response configured for fetchConfig"])
        }
    }
}
