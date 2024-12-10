//
//  KeychainManagerTests.swift
//  Applivery
//
//  Created by Fran Alarza on 10/12/24.
//

import Testing
@testable import Applivery
struct KeychainManagerTests {

    let sut: KeychainAccessible
    
    init() {
        sut = Keychain()
    }
    
    @Test func testStoreAndRetrieveKeychainData() async throws {
        let app = AppMock()
        app.stubBundleID = "com.test.app"
        try sut.store("testPassword", for: app.bundleId())
        let retrievedValue = try sut.retrieve(for: app.bundleId())
        #expect(retrievedValue == "testPassword")
        try sut.remove(for: app.bundleId())
        #expect(try sut.retrieve(for: app.bundleId()) == nil)
    }

}
