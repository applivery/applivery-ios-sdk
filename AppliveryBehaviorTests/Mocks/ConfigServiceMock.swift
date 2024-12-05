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
}

