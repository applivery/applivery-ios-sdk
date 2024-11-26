//
//  Test.swift
//  Applivery
//
//  Created by Fran Alarza on 21/11/24.
//

import Testing
@testable import Applivery

struct EnvironmentTests {

    @Test func testGlobalConfigWithCustomHost() async throws {
        let mockEnvironments = MockEnvironments()
        mockEnvironments.setHost("tesla")
        mockEnvironments.setHostDownload("tesla")
        
        let globalConfig = GlobalConfig(environments: mockEnvironments)
        
        #expect(globalConfig.host == "https://sdk-api.tesla.applivery.io")
        #expect(globalConfig.hostDownload == "https://download-api.tesla.applivery.io")
    }
    
    @Test func testGlobalConfigWithNoCustomHost() async throws {
        let mockEnvironments = MockEnvironments()
        let globalConfig = GlobalConfig(environments: mockEnvironments)
        
        #expect(globalConfig.host == "https://sdk-api.applivery.io")
        #expect(globalConfig.hostDownload == "https://download-api.applivery.io")
    }
}
