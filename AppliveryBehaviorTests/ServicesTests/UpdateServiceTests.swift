//
//  UpdateServiceTests.swift
//  Applivery
//
//  Created by Fran Alarza on 5/12/24.
//

import Testing
@testable import Applivery

// Helper to wait for a condition or timeout
func waitUntil(timeout: TimeInterval = 10.0, interval: TimeInterval = 0.01, _ condition: @escaping () -> Bool) {
    let start = Date()
    while !condition() && Date().timeIntervalSince(start) < timeout {
        RunLoop.main.run(until: Date().addingTimeInterval(interval))
    }
}

struct UpdateServiceTests {
    private let client: MockAPIClient
    private let globalConfig: GlobalConfig
    private let sut: DownloadServiceProtocol
    private let userDefaults = UserDefaults(suiteName: "TestDefaults")

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
    func setCheckForUpdatesBackground_initialStateAndToggle() {
        // GIVEN
        let eventDetector = EventDetectorMock()
        let updateService = UpdateService(eventDetector: eventDetector)

        // WHEN set to true
        updateService.setCheckForUpdatesBackground(true)
        // THEN
        #expect(eventDetector.spyListenEventCalled == true)

        // WHEN set to false
        updateService.setCheckForUpdatesBackground(false)
        // THEN
        #expect(eventDetector.spyEndListeningCalled == true)
    }

    @Test func testCheckUpdateForced() async throws {
        // GIVEN
        let appMock = AppMock()
        let eventDetector = EventDetectorMock()
        let configService = ConfigServiceMock()
        let downloadService = DownloadService()
        let loginService = LoginService()
        let globalConfig = GlobalConfig()
        let updateService = UpdateService(
            configService: configService,
            downloadService: downloadService,
            app: appMock,
            loginService: loginService,
            globalConfig: globalConfig,
            eventDetector: eventDetector
        )
        let forceUpdateConfig = UpdateConfigResponse(
            config: SDKData(
                minVersion: "101",   // <-- This is the buildnumber the app must have
                forceUpdate: true,   // <-- when forceUpdate is set to true
                lastBuildId: nil,
                mustUpdateMsg: nil,
                ota: false,
                lastBuildVersion: "101",
                updateMsg: nil,
                forceAuth: false,
                lastBuildSize: nil
            ),
            version: "0.9.0",  // <-- This is essentially irrelevant
            buildNumber: "100" // <-- This is the app buildNumber
        )
        configService.currentConfigResponse = forceUpdateConfig
        // WHEN
        updateService.checkUpdate(for: forceUpdateConfig, forceUpdate: true)
        // Wait until the async force update is called or timeout
        waitUntil { appMock.spyForceUpdateCalled }
        // THEN
        #expect(appMock.spyForceUpdateCalled == true)
    }

    @Test func testCheckUpdateForcedNotNeeded() async throws {
        // GIVEN
        let appMock = AppMock()
        let eventDetector = EventDetectorMock()
        let configService = ConfigServiceMock()
        let downloadService = DownloadService()
        let loginService = LoginService()
        let globalConfig = GlobalConfig()
        let updateService = UpdateService(
            configService: configService,
            downloadService: downloadService,
            app: appMock,
            loginService: loginService,
            globalConfig: globalConfig,
            eventDetector: eventDetector
        )
        let forceUpdateConfig = UpdateConfigResponse(
            config: SDKData(
                minVersion: "101",   // <-- This is the buildnumber the app must have
                forceUpdate: true,   // <-- when forceUpdate is set to true
                lastBuildId: nil,
                mustUpdateMsg: nil,
                ota: false,
                lastBuildVersion: "101",
                updateMsg: nil,
                forceAuth: false,
                lastBuildSize: nil
            ),
            version: "0.9.0",  // <-- This is essentially irrelevant
            buildNumber: "101" // <-- This is the app buildNumber
        )
        configService.currentConfigResponse = forceUpdateConfig
        // WHEN
        updateService.checkUpdate(for: forceUpdateConfig, forceUpdate: true)
        // Wait until the async force update is called or timeout
        waitUntil { appMock.spyForceUpdateCalled }
        // THEN
        #expect(appMock.spyForceUpdateCalled == false)
    }

    @Test func testCheckOtaUpdate() async throws {
        // GIVEN
        let appMock = AppMock()
        let eventDetector = EventDetectorMock()
        let configService = ConfigServiceMock()
        let downloadService = DownloadService()
        let loginService = LoginService()
        let globalConfig = GlobalConfig()
        let updateService = UpdateService(
            configService: configService,
            downloadService: downloadService,
            app: appMock,
            loginService: loginService,
            globalConfig: globalConfig,
            eventDetector: eventDetector
        )
        let forceUpdateConfig = UpdateConfigResponse(
            config: SDKData(
                minVersion: nil,
                forceUpdate: true,
                lastBuildId: nil,
                mustUpdateMsg: nil,
                ota: true,
                lastBuildVersion: "101",
                updateMsg: nil,
                forceAuth: false,
                lastBuildSize: nil
            ),
            version: "0.9.0",  // <-- This is essentially irrelevant
            buildNumber: "100" // <-- This is the app buildNumber
        )
        configService.currentConfigResponse = forceUpdateConfig
        // WHEN
        updateService.checkUpdate(for: forceUpdateConfig, forceUpdate: false)
        // Wait until the async force update is called or timeout
        waitUntil { appMock.spyForceUpdateCalled }
        // THEN
        #expect(appMock.spyOtaAlert.called == true)
    }

    @Test func testCheckOtaUpdateNotNeeded() async throws {
        // GIVEN
        let appMock = AppMock()
        let eventDetector = EventDetectorMock()
        let configService = ConfigServiceMock()
        let downloadService = DownloadService()
        let loginService = LoginService()
        let globalConfig = GlobalConfig()
        let updateService = UpdateService(
            configService: configService,
            downloadService: downloadService,
            app: appMock,
            loginService: loginService,
            globalConfig: globalConfig,
            eventDetector: eventDetector
        )
        let forceUpdateConfig = UpdateConfigResponse(
            config: SDKData(
                minVersion: nil,
                forceUpdate: true,
                lastBuildId: nil,
                mustUpdateMsg: nil,
                ota: true,
                lastBuildVersion: "101",
                updateMsg: nil,
                forceAuth: false,
                lastBuildSize: nil
            ),
            version: "0.9.0",  // <-- This is essentially irrelevant
            buildNumber: "102" // <-- This is the app buildNumber
        )
        configService.currentConfigResponse = forceUpdateConfig
        // WHEN
        updateService.checkUpdate(for: forceUpdateConfig, forceUpdate: false)
        // Wait until the async force update is called or timeout
        waitUntil { appMock.spyForceUpdateCalled }
        // THEN
        #expect(appMock.spyOtaAlert.called == false)
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
