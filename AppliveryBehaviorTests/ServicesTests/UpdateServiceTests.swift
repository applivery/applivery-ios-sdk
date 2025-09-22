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

    @Test
    func setCheckForUpdatesBackground() {
        // GIVEN
        let mockUpdateService = MockUpdateService()

        // WHEN
        mockUpdateService.setCheckForUpdatesBackground(true)

        // THEN
        #expect(mockUpdateService.setCheckForUpdatesBackgroundCalled == true)
        #expect(mockUpdateService.setCheckForUpdatesBackgroundEnabled == true)

        // WHEN
        mockUpdateService.setCheckForUpdatesBackground(false)

        // THEN
        #expect(mockUpdateService.setCheckForUpdatesBackgroundCalled == true)
        #expect(mockUpdateService.setCheckForUpdatesBackgroundEnabled == false)
    }

    @Test
    func setCheckForUpdatesBackground_initialStateAndToggle() {
        // GIVEN
        let mockUpdateService = MockUpdateService()

        // initial state
        #expect(mockUpdateService.setCheckForUpdatesBackgroundCalled == false)
        #expect(mockUpdateService.setCheckForUpdatesBackgroundEnabled == nil)

        // WHEN set to true
        mockUpdateService.setCheckForUpdatesBackground(true)

        // THEN
        #expect(mockUpdateService.setCheckForUpdatesBackgroundCalled == true)
        #expect(mockUpdateService.setCheckForUpdatesBackgroundEnabled == true)

        // WHEN set to false
        mockUpdateService.setCheckForUpdatesBackground(false)

        // THEN last value is false
        #expect(mockUpdateService.setCheckForUpdatesBackgroundEnabled == false)

        // WHEN set to true again
        mockUpdateService.setCheckForUpdatesBackground(true)

        // THEN last value is true
        #expect(mockUpdateService.setCheckForUpdatesBackgroundEnabled == true)
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
