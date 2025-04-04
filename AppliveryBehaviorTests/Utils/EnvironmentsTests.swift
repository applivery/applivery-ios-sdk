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

    func test_setHost_withAppliveryDomain_keepsItUnchanged() {
        environments.setHost("custom.applivery.io")
        let result = environments.getHost()
        XCTAssertEqual(result, "sdk-api.custom.applivery.io")
    }

    func test_setHost_withTrailingSpaces_trimsAndAddsDefaultDomain() {
        environments.setHost("  customTenant  ")
        let result = environments.getHost()
        XCTAssertEqual(result, "sdk-api.customTenant.applivery.io")
    }

    func test_setHost_withDomainAndTrailingSpaces_trimsAndKeepsOriginalDomain() {
        environments.setHost(" custom.tenant.com ")
        let result = environments.getHost()
        XCTAssertEqual(result, "sdk-api.custom.tenant.com")
    }

    func test_setHost_withUppercaseCharacters_preservesCase() {
        environments.setHost("CUSTOMtenant")
        let result = environments.getHost()
        XCTAssertEqual(result, "sdk-api.CUSTOMtenant.applivery.io")
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

    func test_setHostDownload_withAppliveryDomain_keepsItUnchanged() {
        environments.setHostDownload("custom.applivery.io")
        let result = environments.getHostDownload()
        XCTAssertEqual(result, "download-api.custom.applivery.io")
    }

    func test_setHostDownload_withTrailingSpaces_trimsAndAddsDefaultDomain() {
        environments.setHostDownload("  customTenant  ")
        let result = environments.getHostDownload()
        XCTAssertEqual(result, "download-api.customTenant.applivery.io")
    }

    func test_setHostDownload_withDomainAndTrailingSpaces_trimsAndKeepsOriginalDomain() {
        environments.setHostDownload(" custom.tenant.com ")
        let result = environments.getHostDownload()
        XCTAssertEqual(result, "download-api.custom.tenant.com")
    }

    func test_setHostDownload_withUppercaseCharacters_preservesCase() {
        environments.setHostDownload("CUSTOMtenant")
        let result = environments.getHostDownload()
        XCTAssertEqual(result, "download-api.CUSTOMtenant.applivery.io")
    }
}
