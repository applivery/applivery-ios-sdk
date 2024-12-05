//
//  UpdateServiceTests.swift
//  Applivery
//
//  Created by Fran Alarza on 5/12/24.
//

import Testing
@testable import Applivery

struct UpdateServiceTests {
    
    private let client: MockAPIClient
    private let globalConfig: GlobalConfig
    private let sut: DownloadServiceProtocol
    
    init() {
        self.client = MockAPIClient()
        self.globalConfig = GlobalConfig()
        self.sut = DownloadService(
            client: client,
            globalConfig: globalConfig
        )
    }
    
    @Test
    func fetchDownloadTokenSuccess() async throws {
        // GIVEN
        let expectedToken = DownloadTokenMock.downloadTokenMock
        client.fetchHandler = { endpoint in
            #expect(endpoint.path == "/v1/build/1234/downloadToken")
            return expectedToken
        }
        
        // WHEN
        let token = await sut.fetchDownloadToken(with: "1234")
        
        // THEN
        #expect(token?.data.token == "TOKEN_TEST")
    }
    
    @Test
    func fetchDownloadTokenError() async throws {

        // WHEN
        let token = await sut.fetchDownloadToken(with: "1234")
        
        // THEN
        #expect(token == nil)
    }
    
    @Test
    func downloadURLWithToken() async throws {
        // GIVEN
        let expectedToken = DownloadTokenMock.downloadTokenMock
        client.fetchHandler = { endpoint in
            #expect(endpoint.path == "/v1/build/1234/downloadToken")
            return expectedToken
        }
        
        // WHEN
        let url = await sut.downloadURL("1234")
        
        // THEN
        #expect(url == "itms-services://?action=download-manifest&url=https://\(globalConfig.hostDownload)/v1/download/TOKEN_TEST/manifest.plist")
    }
    
    @Test
    func downloadURLWithoutToken() async throws {
        // GIVEN
        
        // WHEN
        let url = await sut.downloadURL("1234")
        
        // THEN
        #expect(url == nil)
    }
}

struct DownloadTokenMock {
    static let downloadTokenMock: DownloadToken = .init(
        status: true,
        data: .init(
            token: "TOKEN_TEST"
        )
    )
}
