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
        mockEnvironments.setHost("applivery.com")
        mockEnvironments.setHostDownload("download-applivery.com")
        
        let globalConfig = GlobalConfig(environments: mockEnvironments)
        
        #expect(globalConfig.host == "https://applivery.com")
        #expect(globalConfig.hostDownload == "https://download-applivery.com")
    }
    
    @Test func testGlobalConfigWithNoCustomHost() async throws {
        let mockEnvironments = MockEnvironments()
        let globalConfig = GlobalConfig(environments: mockEnvironments)
        
        #expect(globalConfig.host == "https://sdk-api.applivery.io")
        #expect(globalConfig.hostDownload == "https://download-api.applivery.io")
    }
}
