//
//  ConfigMockData.swift
//  Applivery
//
//  Created by Fran Alarza on 5/12/24.
//

import Foundation
@testable import Applivery

struct ConfigMockData {
    
    static let config = Config(
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
