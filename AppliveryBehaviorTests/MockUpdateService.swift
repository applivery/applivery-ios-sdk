//
//  MockUpdateService.swift
//  Applivery
//
//  Created by Fran Alarza on 5/12/24.
//

import UIKit
@testable import Applivery

class MockUpdateService: PUpdateInteractor {
    
    var output: (UpdateInteractorOutput)? = nil
    

    // MARK: - Spy Properties
    var forceUpdateCalled = false
    var otaUpdateCalled = false
    var downloadLastBuildCalled = false
    var isUpToDateResponse: Bool = true
    var checkForceUpdateResponse: Bool = false
    var checkOtaUpdateResponse: Bool = false
    var forceUpdateMessageResponse: String = "Mock force update message"
    var otaUpdateMessageResponse: String = "Mock OTA update message"

    // MARK: - Protocol Methods
    func forceUpdate() {
        forceUpdateCalled = true
    }

    func otaUpdate() {
        otaUpdateCalled = true
    }

    func downloadLastBuild() {
        downloadLastBuildCalled = true
    }

    func isUpToDate() -> Bool {
        return isUpToDateResponse
    }

    func checkForceUpdate(_ config: Config?, version: String) -> Bool {
        return checkForceUpdateResponse
    }

    func checkOtaUpdate(_ config: Config?, version: String) -> Bool {
        return checkOtaUpdateResponse
    }

    func forceUpdateMessage() -> String {
        return forceUpdateMessageResponse
    }

    func otaUpdateMessage() -> String {
        return otaUpdateMessageResponse
    }
}
