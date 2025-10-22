//
//  LoginServiceTests.swift
//  AppliverySDK
//
//  Created by Abigail Dominguez Morlans on 30/9/25.
//  Copyright © 2025 Applivery S.L. All rights reserved.
//

import Testing
@testable import Applivery

struct LoginServiceTests {
    @Test
    func testLoginSuccess() async throws {
        let loginRepository = LoginRepositoryMock()
        let configService = ConfigServiceMock()
        let downloadService = DownloadServiceMock()
        let globalConfig = GlobalConfig.shared
        let sessionPersister = MockSessionPersister()
        let app = AppMock()
        let keychain = MockKeychainManager()
        let forceUpdateConfig = UpdateConfigResponse(
            config: SDKData.mock,
            version: "0.9.0",
            buildNumber: "100"
        )
        configService.currentConfigResponse = forceUpdateConfig
        let loginService = LoginService(
            loginRepository: loginRepository,
            configService: configService,
            downloadService: downloadService,
            globalConfig: globalConfig,
            sessionPersister: sessionPersister,
            app: app,
            keychain: keychain
        )
        loginRepository.shouldSucceed = true
        let loginData = LoginData(provider: "provider", payload: .init(user: "test@applivery.com", password: "pass"))
        await loginService.login(loginData: loginData)
        #expect(sessionPersister.didSaveUserName)
    }
    
    @Test
    func testLoginFailure401() async {
        let loginRepository = LoginRepositoryMock()
        let configService = ConfigServiceMock()
        let downloadService = DownloadServiceMock()
        let globalConfig = GlobalConfig.shared
        let sessionPersister = MockSessionPersister()
        let app = AppMock()
        let keychain = MockKeychainManager()
        let forceUpdateConfig = UpdateConfigResponse(
            config: SDKData.mock,
            version: "0.9.0",
            buildNumber: "100"
        )
        configService.currentConfigResponse = forceUpdateConfig
        let loginService = LoginService(
            loginRepository: loginRepository,
            configService: configService,
            downloadService: downloadService,
            globalConfig: globalConfig,
            sessionPersister: sessionPersister,
            app: app,
            keychain: keychain
        )
        loginRepository.shouldReturn401 = true
        let loginData = LoginData(provider: "provider", payload: .init(user: "test@applivery.com", password: "pass"))
        await loginService.login(loginData: loginData)
        // No assertion for SafariManager side effect since it is now a noop
    }
    /*
    @Test
    func testRequestAuthorizationWithToken() async {
        let loginRepository = LoginRepositoryMock()
        let configService = ConfigServiceMock()
        let downloadService = DownloadServiceMock()
        let globalConfig = GlobalConfig.shared
        let sessionPersister = MockSessionPersister()
        let app = AppMock()
        let keychain = MockKeychainManager()
        let forceUpdateConfig = UpdateConfigResponse(
            config: SDKData.mock,
            version: "0.9.0",
            buildNumber: "100"
        )
        configService.currentConfigResponse = forceUpdateConfig
        let loginService = LoginService(
            loginRepository: loginRepository,
            configService: configService,
            downloadService: downloadService,
            globalConfig: globalConfig,
            sessionPersister: sessionPersister,
            app: app,
            keychain: keychain
        )
        // Ensure bundle ID is set before storing the token
        app.stubBundleID = "com.applivery.test"
        try? keychain.store("token", for: app.stubBundleID)
        downloadService.stubbedURL = "https://applivery.com/app.ipa"
        var downloadCalled = false
        loginService.requestAuthorization(onResult: { _ in downloadCalled = true })
        waitUntil { downloadService.downloadURLCalled && downloadCalled }
        await MainActor.run {
            print("downloadService.downloadURLCalled: \(downloadService.downloadURLCalled)")
            print("downloadCalled: \(downloadCalled)")
            #expect(downloadService.downloadURLCalled)
            #expect(downloadCalled)
        }
    }
    */
    @Test
    func testRequestAuthorizationWithTokenNUEVO() async {
        let loginRepository = LoginRepositoryMock()
        let configService = ConfigServiceMock()
        let downloadService = DownloadServiceMock()
        let globalConfig = GlobalConfig.shared
        let sessionPersister = MockSessionPersister()
        let app = AppMock()
        let keychain = MockKeychainManager()
        let forceUpdateConfig = UpdateConfigResponse(
            config: SDKData.mock,
            version: "0.9.0",
            buildNumber: "100"
        )
        configService.currentConfigResponse = forceUpdateConfig
        let loginService = LoginService(
            loginRepository: loginRepository,
            configService: configService,
            downloadService: downloadService,
            globalConfig: globalConfig,
            sessionPersister: sessionPersister,
            app: app,
            keychain: keychain
        )
        // Ensure bundle ID is set before storing the token
        app.stubBundleID = "com.applivery.test"
        app.stubOpenUrlResult = true
        try? keychain.store("token", for: app.stubBundleID)
        downloadService.stubbedURL = "https://applivery.com/app.ipa"
        var downloadCalled = false
        loginService.requestAuthorization(onResult: { _ in
            
            DispatchQueue.main.async {
                downloadCalled = true
                #expect(downloadService.downloadURLCalled)
                #expect(downloadCalled)
            }
        })
    }
/*
    @Test
    func testRequestAuthorizationWithToken22() async {
        let loginRepository = LoginRepositoryMock()
        let configService = ConfigServiceMock()
        let downloadService = DownloadServiceMock()
        let globalConfig = GlobalConfig.shared
        let sessionPersister = MockSessionPersister()
        let app = AppMock()
        let keychain = MockKeychainManager()
        let forceUpdateConfig = UpdateConfigResponse(
            config: SDKData.mock,
            version: "0.9.0",
            buildNumber: "100"
        )
        configService.currentConfigResponse = forceUpdateConfig
        let loginService = LoginService(
            loginRepository: loginRepository,
            configService: configService,
            downloadService: downloadService,
            globalConfig: globalConfig,
            sessionPersister: sessionPersister,
            app: app,
            keychain: keychain
        )
        // Ensure bundle ID is set before storing the u token
        app.stubBundleID = "com.applivery.test"
        app.stubOpenUrlResult = true
        try? keychain.store("token", for: app.stubBundleID)
        downloadService.stubbedURL = "https://applivery.com/app.ipa"
        var downloadCalled = false
       // loginService.requestAuthorization(onResult: { _ in downloadCalled = true })

/*
        await confirmation("Synchronizer completes") { @MainActor confirm in
            await MainActor.run {
                loginService.requestAuthorization { _ in
                    downloadCalled = true
                    #expect(downloadService.downloadURLCalled)
                    #expect(downloadCalled)
                    confirm()
                }
            }
        }*/
        await confirmation { confirmation in
            loginService.requestAuthorization { _ in
                downloadCalled = true
                confirmation.confirm()
            }
        }
        #expect(downloadService.downloadURLCalled)
        #expect(downloadCalled)
        
    }
    */

    @Test
    func testRequestAuthorizationWithoutToken() async {
        let loginRepository = LoginRepositoryMock()
        let configService = ConfigServiceMock()
        let downloadService = DownloadServiceMock()
        let globalConfig = GlobalConfig.shared
        let sessionPersister = MockSessionPersister()
        let app = AppMock()
        let keychain = MockKeychainManager()
        let forceUpdateConfig = UpdateConfigResponse(
            config: SDKData.mock,
            version: "0.9.0",
            buildNumber: "100"
        )
        configService.currentConfigResponse = forceUpdateConfig
        let loginService = LoginService(
            loginRepository: loginRepository,
            configService: configService,
            downloadService: downloadService,
            globalConfig: globalConfig,
            sessionPersister: sessionPersister,
            app: app,
            keychain: keychain
        )
        try? keychain.remove(for: "com.applivery.test")
        var result: UpdateResult?
        loginService.requestAuthorization { r in result = r }
        waitUntil { result != nil }
        #expect(result?.type == .error)
        #expect(result?.error == .authRequired)
    }

    @Test
    func testDownloadInsufficientDiskSpace() async {
        let loginRepository = LoginRepositoryMock()
        let configService = ConfigServiceMock()
        let downloadService = DownloadServiceMock()
        let globalConfig = GlobalConfig.shared
        let sessionPersister = MockSessionPersister()
        let app = AppMock()
        let keychain = MockKeychainManager()
        let forceUpdateConfig = UpdateConfigResponse(
            config: SDKData.mock,
            version: "0.9.0",
            buildNumber: "100"
        )
        configService.currentConfigResponse = forceUpdateConfig
        let loginService = LoginService(
            loginRepository: loginRepository,
            configService: configService,
            downloadService: downloadService,
            globalConfig: globalConfig,
            sessionPersister: sessionPersister,
            app: app,
            keychain: keychain
        )
        app.stubDeviceAvailableSpace = 1000
        var result: UpdateResult?
        loginService.download { r in result = r }
        waitUntil { result != nil }
        #expect(result?.type == .error)
        #expect(result?.error == .noDiskSpaceAvailable)
    }

    @Test
    func testDownloadSufficientDiskSpace() async {
        let loginRepository = LoginRepositoryMock()
        let configService = ConfigServiceMock()
        let downloadService = DownloadServiceMock()
        let globalConfig = GlobalConfig.shared
        let sessionPersister = MockSessionPersister()
        let app = AppMock()
        let keychain = MockKeychainManager()
        let forceUpdateConfig = UpdateConfigResponse(
            config: SDKData.mock,
            version: "0.9.0",
            buildNumber: "100"
        )
        app.stubDeviceAvailableSpace = 6000000000
        app.stubOpenUrlResult = true
        configService.currentConfigResponse = forceUpdateConfig
        let loginService = LoginService(
            loginRepository: loginRepository,
            configService: configService,
            downloadService: downloadService,
            globalConfig: globalConfig,
            sessionPersister: sessionPersister,
            app: app,
            keychain: keychain
        )

        downloadService.stubbedURL = "https://applivery.com/app.ipa"
        var result: UpdateResult?
        loginService.download { r in result = r }
        waitUntil { result != nil && downloadService.downloadURLCalled }
        #expect(result?.type == .success)
        #expect(downloadService.downloadURLCalled)
    }
}
