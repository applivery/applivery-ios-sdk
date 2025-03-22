//
//  EnvironmentsTests.swift
//  Applivery
//
//  Created by Alejandro on 22/3/25.
//


//
//  EnvironmentsTests.swift
//  AppliveryBehaviorTests
//
//  Created by Alejandro on 22/3/25.
//  Copyright © 2025 Applivery S.L. All rights reserved.
//

import XCTest
@testable import Applivery

final class EnvironmentsTests: XCTestCase {

    private var environments: Environments!
    private var userDefaults: UserDefaults!

    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: "TestDefaults")
        userDefaults.removePersistentDomain(forName: "TestDefaults")
        environments = Environments(userDefaults: userDefaults, processInfo: ProcessInfo.processInfo)
    }

    override func tearDown() {
        userDefaults.removePersistentDomain(forName: "TestDefaults")
        userDefaults = nil
        environments = nil
        super.tearDown()
    }

    // MARK: - setHost Tests

    func test_setHost_withNilTenant_usesDefaultDomain() {
        environments.setHost(nil)
        let result = environments.getHost()
        XCTAssertEqual(result, "sdk-api.applivery.io")
    }

    func test_setHost_withEmptyTenant_usesDefaultDomain() {
        environments.setHost("")
        let result = environments.getHost()
        XCTAssertEqual(result, "sdk-api.applivery.io")
    }

    func test_setHost_withWhitespaceTenant_trimsAndUsesDefaultDomain() {
        environments.setHost("   ")
        let result = environments.getHost()
        XCTAssertEqual(result, "sdk-api.applivery.io")
    }

    func test_setHost_withSubdomain_addsDefaultDomain() {
        environments.setHost("customTenant")
        let result = environments.getHost()
        XCTAssertEqual(result, "sdk-api.customTenant.applivery.io")
    }

    func test_setHost_withFullDomain_keepsItUnchanged() {
        environments.setHost("custom.tenant.com")
        let result = environments.getHost()
        XCTAssertEqual(result, "sdk-api.custom.tenant.com")
    }

    // MARK: - setHostDownload Tests

    func test_setHostDownload_withNilTenant_usesDefaultDomain() {
        environments.setHostDownload(nil)
        let result = environments.getHostDownload()
        XCTAssertEqual(result, "download-api.applivery.io")
    }

    func test_setHostDownload_withEmptyTenant_usesDefaultDomain() {
        environments.setHostDownload("")
        let result = environments.getHostDownload()
        XCTAssertEqual(result, "download-api.applivery.io")
    }

    func test_setHostDownload_withWhitespaceTenant_trimsAndUsesDefaultDomain() {
        environments.setHostDownload("   ")
        let result = environments.getHostDownload()
        XCTAssertEqual(result, "download-api.applivery.io")
    }

    func test_setHostDownload_withSubdomain_addsDefaultDomain() {
        environments.setHostDownload("customTenant")
        let result = environments.getHostDownload()
        XCTAssertEqual(result, "download-api.customTenant.applivery.io")
    }

    func test_setHostDownload_withFullDomain_keepsItUnchanged() {
        environments.setHostDownload("custom.tenant.com")
        let result = environments.getHostDownload()
        XCTAssertEqual(result, "download-api.custom.tenant.com")
    }
}
