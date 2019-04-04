//
//  StartInteractorTests.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 4/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import XCTest
@testable import Applivery

class StartInteractorTests: XCTestCase {

	var startInteractor: StartInteractor!
	var configDataManagerMock: ConfigDataManagerMock!
	var startInteractorOutputMock: StartInteractorOutputMock!
	var globalConfigMock: GlobalConfig!
	var eventDetectorMock: EventDetectorMock!


    override func setUp() {
        super.setUp()

		self.configDataManagerMock = ConfigDataManagerMock()
		self.configDataManagerMock.inCurrentConfig = Config()
		self.startInteractorOutputMock = StartInteractorOutputMock()
		self.globalConfigMock = GlobalConfig()
		self.eventDetectorMock = EventDetectorMock()

		self.startInteractor = StartInteractor(
			configDataManager: self.configDataManagerMock,
			globalConfig: self.globalConfigMock,
			eventDetector: self.eventDetectorMock
		)
		self.startInteractor.output = self.startInteractorOutputMock
		self.globalConfigMock.appToken = "appToken TEST"
		self.globalConfigMock.appId = "APPID TEST"
    }

    override func tearDown() {
		self.startInteractor = nil

        super.tearDown()
    }

    func test_not_nil() {
		XCTAssertNotNil(self.startInteractor)
    }


	// MARK: - No Force Update

	func test_UpdatedConfigNoForceUpdate_result_NoForceUpdate() {
		let appVersion = "1.2.1.5"
		self.updatedConfigNoForceUpdate(appVersion)

		self.startInteractor.start()

		XCTAssert(self.configDataManagerMock.outUpdateConfigCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyForceUpdateCalled == false)
		XCTAssert(self.startInteractorOutputMock.spyOtaUpdateCalled == false)
		XCTAssert(self.eventDetectorMock.spyListenEventCalled == true)
	}

	func test_UpdatedConfigNoShouldUpdate_result_NoForceUpdate() {
		let appVersion = "1.2.1.5"
		self.updatedConfigNoShouldUpdate(appVersion)

		self.startInteractor.start()

		XCTAssert(self.configDataManagerMock.outUpdateConfigCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyForceUpdateCalled == false)
		XCTAssert(self.startInteractorOutputMock.spyOtaUpdateCalled == false)
		XCTAssert(self.eventDetectorMock.spyListenEventCalled == true)
	}

	func test_UpdatedConfigNoShouldUpdate_withDifferentVersionLength_result_NoForceUpdate() {
		let appVersion = "1.2"
		self.updatedConfigNoShouldUpdate(appVersion, minVersion: "1.0.0.0")

		self.startInteractor.start()

		XCTAssert(self.configDataManagerMock.outUpdateConfigCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyForceUpdateCalled == false)
		XCTAssert(self.startInteractorOutputMock.spyOtaUpdateCalled == false)
		XCTAssert(self.eventDetectorMock.spyListenEventCalled == true)
	}

	func test_UpdatedConfigNoShouldUpdate_withSameVersion_result_NoForceUpdate() {
		let appVersion = "1.0"
		self.updatedConfigNoShouldUpdate(appVersion)

		self.startInteractor.start()

		XCTAssert(self.configDataManagerMock.outUpdateConfigCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyForceUpdateCalled == false)
		XCTAssert(self.startInteractorOutputMock.spyOtaUpdateCalled == false)
		XCTAssert(self.eventDetectorMock.spyListenEventCalled == true)
	}

	func test_UpdatedConfigNoShouldUpdate_withSameVersion_butDifferentLength_result_NoForceUpdate() {
		let appVersion = "1.0"
		self.updatedConfigNoShouldUpdate(appVersion, minVersion: "1.0.0.0")

		self.startInteractor.start()

		XCTAssert(self.configDataManagerMock.outUpdateConfigCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyForceUpdateCalled == false)
		XCTAssert(self.startInteractorOutputMock.spyOtaUpdateCalled == false)
		XCTAssert(self.eventDetectorMock.spyListenEventCalled == true)
	}

	func test_UpdatedConfigNoShouldUpdate_withSameVersion_butDifferentReverseLength_result_NoForceUpdate() {
		let appVersion = "1.0.0.0"
		self.updatedConfigNoShouldUpdate(appVersion)

		self.startInteractor.start()

		XCTAssert(self.configDataManagerMock.outUpdateConfigCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyForceUpdateCalled == false)
		XCTAssert(self.startInteractorOutputMock.spyOtaUpdateCalled == false)
		XCTAssert(self.eventDetectorMock.spyListenEventCalled == true)
	}

	func test_UpdatedConfigIsMinorVersion_result_NoForceUpdate() {
		let appVersion = "1.25.3"
		self.updatedConfigNoShouldUpdate(appVersion, minVersion: "1.3.54")

		self.startInteractor.start()

		XCTAssert(self.configDataManagerMock.outUpdateConfigCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyForceUpdateCalled == false)
		XCTAssert(self.startInteractorOutputMock.spyOtaUpdateCalled == false)
		XCTAssert(self.eventDetectorMock.spyListenEventCalled == true)
	}

	func test_CurrentConfigShouldForceUpdate_but_UpdatedConfigNoForceUpdate_result_NoForceUpdate() {
		let appVersion = "1.2.1.5"
		self.currentConfigShouldForceUpdate(appVersion)
		self.updatedConfigNoForceUpdate(appVersion)

		self.startInteractor.start()

		XCTAssert(self.configDataManagerMock.outUpdateConfigCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyForceUpdateCalled == false)
		XCTAssert(self.startInteractorOutputMock.spyOtaUpdateCalled == false)
		XCTAssert(self.eventDetectorMock.spyListenEventCalled == true)
	}

	func test_CurrentConfigShouldForceUpdate_but_UpdatedConfigNoShouldUpdate_returns_NoForceUpdate() {
		let appVersion = "1.2.1.5"
		self.currentConfigShouldForceUpdate(appVersion)
		self.updatedConfigNoShouldUpdate(appVersion)

		self.startInteractor.start()

		XCTAssert(self.configDataManagerMock.outUpdateConfigCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyForceUpdateCalled == false)
		XCTAssert(self.startInteractorOutputMock.spyOtaUpdateCalled == false)
		XCTAssert(self.eventDetectorMock.spyListenEventCalled == true)
	}

	func test_UpdatedConfigFails_CurrentConfigNoForceUpdate_result_NoForceUpdate() {
		let appVersion = "1.2.1.5"
		self.currentConfigNoForceUpdate(appVersion)
		self.configDataManagerMock.inUpdateConfigResponse = .error

		self.startInteractor.start()

		XCTAssert(self.configDataManagerMock.outUpdateConfigCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyForceUpdateCalled == false)
		XCTAssert(self.startInteractorOutputMock.spyOtaUpdateCalled == false)
		XCTAssert(self.eventDetectorMock.spyListenEventCalled == true)
	}

	func test_UpdatedConfigFails_CurrentConfigNoShouldUpdate_result_NoForceUpdate() {
		let appVersion = "1.2.1.5"
		self.currentConfigNoShouldUpdate(appVersion)
		self.configDataManagerMock.inUpdateConfigResponse = .error

		self.startInteractor.start()

		XCTAssert(self.configDataManagerMock.outUpdateConfigCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyForceUpdateCalled == false)
		XCTAssert(self.startInteractorOutputMock.spyOtaUpdateCalled == false)
		XCTAssert(self.eventDetectorMock.spyListenEventCalled == true)
	}

	func test_UpdatedConfigFails_NoCurrentConfig_result_NoForceUpdate() {
		let appVersion = "1.2.1.5"
		self.configDataManagerMock.stubVersion = appVersion
		self.configDataManagerMock.inCurrentConfig = nil
		self.configDataManagerMock.inUpdateConfigResponse = .error

		self.startInteractor.start()

		XCTAssert(self.configDataManagerMock.outUpdateConfigCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyForceUpdateCalled == false)
		XCTAssert(self.startInteractorOutputMock.spyOtaUpdateCalled == false)
		XCTAssert(self.eventDetectorMock.spyListenEventCalled == true)
	}


	// MARK: - Force update

	func test_UpdatedConfigForceUpdate_result_ForceUpdate() {
		let appVersion = "1.2.1.5"
		self.updatedConfigForceUpdate(appVersion)

		self.startInteractor.start()

		XCTAssert(self.configDataManagerMock.outUpdateConfigCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyForceUpdateCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyOtaUpdateCalled == false)
		XCTAssert(self.eventDetectorMock.spyListenEventCalled == true)
	}

	func test_SameLength_ForceUpdate() {
		let appVersion = "1.2"
		self.updatedConfigForceUpdate(appVersion)

		self.startInteractor.start()

		XCTAssert(self.configDataManagerMock.outUpdateConfigCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyForceUpdateCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyOtaUpdateCalled == false)
		XCTAssert(self.eventDetectorMock.spyListenEventCalled == true)
	}

	func test_DifferentLenghtReversed_ForceUpdate() {
		let appVersion = "1.2"
		self.updatedConfigForceUpdate(appVersion, minVersion: "1.2.1.0")

		self.startInteractor.start()

		XCTAssert(self.configDataManagerMock.outUpdateConfigCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyForceUpdateCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyOtaUpdateCalled == false)
		XCTAssert(self.eventDetectorMock.spyListenEventCalled == true)
	}

	func test_UpdatedConfigForceUpdate_but_CurrentConfigNoForceUpdate_result_ForceUpdate() {
		let appVersion = "1.2.1.5"
		self.updatedConfigForceUpdate(appVersion)
		self.currentConfigNoForceUpdate(appVersion)

		self.startInteractor.start()

		XCTAssert(self.configDataManagerMock.outUpdateConfigCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyForceUpdateCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyOtaUpdateCalled == false)
		XCTAssert(self.eventDetectorMock.spyListenEventCalled == true)
	}

	func test_UpdatedConfigFails_CurrentConfigForceUpdate_result_ForceUpdate() {
		let appVersion = "1.2.1.5"
		self.currentConfigForceUpdate(appVersion)
		self.configDataManagerMock.inUpdateConfigResponse = .error

		self.startInteractor.start()

		XCTAssert(self.configDataManagerMock.outUpdateConfigCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyForceUpdateCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyOtaUpdateCalled == false)
		XCTAssert(self.eventDetectorMock.spyListenEventCalled == true)
	}


	// MARK: - No OTA Update

	func test_UpdatedConfigNoOtaUpdate_result_NoOtaUpdate() {
		let appVersion = "1.2.1.5"
		self.updatedConfigNoOtaUpdate(appVersion)

		self.startInteractor.start()

		XCTAssert(self.configDataManagerMock.outUpdateConfigCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyForceUpdateCalled == false)
		XCTAssert(self.startInteractorOutputMock.spyOtaUpdateCalled == false)
		XCTAssert(self.eventDetectorMock.spyListenEventCalled == true)
	}

	func test_UpdatedConfigOtaNoShouldUpdate_result_NoOtaUpdate() {
		let appVersion = "1.2.1.5"
		self.updatedConfigOtaNoShouldUpdate(appVersion)

		self.startInteractor.start()

		XCTAssert(self.configDataManagerMock.outUpdateConfigCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyForceUpdateCalled == false)
		XCTAssert(self.startInteractorOutputMock.spyOtaUpdateCalled == false)
		XCTAssert(self.eventDetectorMock.spyListenEventCalled == true)
	}

	func test_UpdatedConfigOtaNoShouldUpdate_with_SameVersion_result_NoOtaUpdate() {
		let appVersion = "1.0"
		self.updatedConfigOtaNoShouldUpdate(appVersion)

		self.startInteractor.start()

		XCTAssert(self.configDataManagerMock.outUpdateConfigCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyForceUpdateCalled == false)
		XCTAssert(self.startInteractorOutputMock.spyOtaUpdateCalled == false)
		XCTAssert(self.eventDetectorMock.spyListenEventCalled == true)
	}

	func test_CurrentConfigNoOtaUpdate_result_NoOtaUpdate() {
		let appVersion = "1.2.1.5"
		self.currentConfigNoOtaUpdate(appVersion)
		self.configDataManagerMock.inUpdateConfigResponse = .error

		self.startInteractor.start()

		XCTAssert(self.configDataManagerMock.outUpdateConfigCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyForceUpdateCalled == false)
		XCTAssert(self.startInteractorOutputMock.spyOtaUpdateCalled == false)
		XCTAssert(self.eventDetectorMock.spyListenEventCalled == true)
	}

	func test_CurrentConfigOtaNoShouldUpdate_result_NoOtaUpdate() {
		let appVersion = "1.2.1.5"
		self.currentConfigOtaNoShouldUpdate(appVersion)
		self.configDataManagerMock.inUpdateConfigResponse = .error

		self.startInteractor.start()

		XCTAssert(self.configDataManagerMock.outUpdateConfigCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyForceUpdateCalled == false)
		XCTAssert(self.startInteractorOutputMock.spyOtaUpdateCalled == false)
		XCTAssert(self.eventDetectorMock.spyListenEventCalled == true)
	}

	func test_CurrentConfigOtaNoShouldUpdate_with_SameVersion_result_NoOtaUpdate() {
		let appVersion = "1.0"
		self.currentConfigOtaNoShouldUpdate(appVersion)
		self.configDataManagerMock.inUpdateConfigResponse = .error

		self.startInteractor.start()

		XCTAssert(self.configDataManagerMock.outUpdateConfigCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyForceUpdateCalled == false)
		XCTAssert(self.startInteractorOutputMock.spyOtaUpdateCalled == false)
		XCTAssert(self.eventDetectorMock.spyListenEventCalled == true)
	}

	func test_CurrentConfigShouldForceUpdate_but_UpdatedConfigNoOtaUpdate_result_NoOtaUpdate() {
		let appVersion = "1.2.1.5"
		self.currentConfigShouldForceUpdate(appVersion)
		self.updatedConfigNoOtaUpdate(appVersion)

		self.startInteractor.start()

		XCTAssert(self.configDataManagerMock.outUpdateConfigCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyForceUpdateCalled == false)
		XCTAssert(self.startInteractorOutputMock.spyOtaUpdateCalled == false)
		XCTAssert(self.eventDetectorMock.spyListenEventCalled == true)
	}

	func test_CurrentConfigShouldForceUpdate_but_UpdatedConfigOtaNoShouldUpdate_returns_NoOtaUpdate() {
		let appVersion = "1.2.1.5"
		self.currentConfigShouldForceUpdate(appVersion)
		self.updatedConfigOtaNoShouldUpdate(appVersion)

		self.startInteractor.start()

		XCTAssert(self.configDataManagerMock.outUpdateConfigCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyForceUpdateCalled == false)
		XCTAssert(self.startInteractorOutputMock.spyOtaUpdateCalled == false)
		XCTAssert(self.eventDetectorMock.spyListenEventCalled == true)
	}

	func test_UpdatedConfigFails_CurrentConfigNoOtapdate_result_NoOTAUpdate() {
		let appVersion = "1.2.1.5"
		self.currentConfigNoOtaUpdate(appVersion)
		self.configDataManagerMock.inUpdateConfigResponse = .error

		self.startInteractor.start()

		XCTAssert(self.configDataManagerMock.outUpdateConfigCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyForceUpdateCalled == false)
		XCTAssert(self.startInteractorOutputMock.spyOtaUpdateCalled == false)
		XCTAssert(self.eventDetectorMock.spyListenEventCalled == true)
	}

	func test_UpdatedConfigFails_CurrentConfigOtaNoShouldUpdate_result_NoOtaUpdate() {
		let appVersion = "1.2.1.5"
		self.currentConfigOtaNoShouldUpdate(appVersion)
		self.configDataManagerMock.inUpdateConfigResponse = .error

		self.startInteractor.start()

		XCTAssert(self.configDataManagerMock.outUpdateConfigCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyForceUpdateCalled == false)
		XCTAssert(self.startInteractorOutputMock.spyOtaUpdateCalled == false)
		XCTAssert(self.eventDetectorMock.spyListenEventCalled == true)
	}


	// MARK: - Ota update

	func test_UpdatedConfigOtaUpdate() {
		let appVersion = "1.2.1.5"
		self.updatedConfigOtaUpdate(appVersion)
		self.startInteractor.start()

		XCTAssert(self.configDataManagerMock.outUpdateConfigCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyForceUpdateCalled == false)
		XCTAssert(self.startInteractorOutputMock.spyOtaUpdateCalled == true)
		XCTAssert(self.eventDetectorMock.spyListenEventCalled == true)
	}

	func test_UpdatedConfigOtaUpdate_but_CurrentConfigNoOtaUpdate_result_OtaUpdate() {
		let appVersion = "1.2.1.5"
		self.updatedConfigOtaUpdate(appVersion)
		self.currentConfigNoOtaUpdate(appVersion)

		self.startInteractor.start()

		XCTAssert(self.configDataManagerMock.outUpdateConfigCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyForceUpdateCalled == false)
		XCTAssert(self.startInteractorOutputMock.spyOtaUpdateCalled == true)
		XCTAssert(self.eventDetectorMock.spyListenEventCalled == true)
	}

	func test_UpdatedConfigFails_CurrentConfigOtaUpdate_result_OtaUpdate() {
		let appVersion = "1.2.1.5"
		self.currentConfigOtaUpdate(appVersion)
		self.configDataManagerMock.inUpdateConfigResponse = .error

		self.startInteractor.start()

		XCTAssert(self.configDataManagerMock.outUpdateConfigCalled == true)
		XCTAssert(self.startInteractorOutputMock.spyForceUpdateCalled == false)
		XCTAssert(self.startInteractorOutputMock.spyOtaUpdateCalled == true)
		XCTAssert(self.eventDetectorMock.spyListenEventCalled == true)
	}


	// MARK: - Store Release

	func test_shouldForceUpdate_but_StoreReleaseIsTrue_result_noUpdate() {
		let appVersion = "1.2.1.5"
		self.globalConfigMock.appStoreRelease = true
		self.currentConfigForceUpdate(appVersion)
		self.updatedConfigForceUpdate(appVersion)

		self.startInteractor.start()

		XCTAssert(self.configDataManagerMock.outUpdateConfigCalled == false)
		XCTAssert(self.startInteractorOutputMock.spyForceUpdateCalled == false)
		XCTAssert(self.startInteractorOutputMock.spyOtaUpdateCalled == false)
		XCTAssert(self.eventDetectorMock.spyListenEventCalled == true)
	}

	// MARK: - OnDetection Event
	func test_startInteractor_callsOutputFeedback_whenEventDetected() {
		self.startInteractor.start() // Mock should get onDetection closure

		self.eventDetectorMock.spyOnDetectionClosure()

		XCTAssert(self.startInteractorOutputMock.spyFeedbackEventCalled == true)
	}


	// MARK: - Disable Feedback test

	func test_disableFeedback_endListening_whenFeedbackIsEnabled() {
		XCTAssert(self.globalConfigMock.feedbackEnabled == true)

		self.startInteractor.disableFeedback()

		XCTAssert(self.globalConfigMock.feedbackEnabled == false)
		XCTAssert(self.eventDetectorMock.spyEndListeningCalled == true)
	}

	func test_disableFeedback_doNothing_whenFeedbackIsDisabled() {
		self.globalConfigMock.feedbackEnabled = false

		self.startInteractor.disableFeedback()

		XCTAssert(self.globalConfigMock.feedbackEnabled == false)
		XCTAssert(self.eventDetectorMock.spyEndListeningCalled == false)
	}


	// MARK: - Helpers

	// Force Update

	func updatedConfigNoForceUpdate(_ appVersion: String) {
		let updatedConfig = Config()
		updatedConfig.minVersion = "2.0"
		updatedConfig.forceUpdate = false
		updatedConfig.otaUpdate = false
		updatedConfig.lastVersion = "1.0"
		self.configDataManagerMock.inUpdateConfigResponse = .success(config: updatedConfig, version: appVersion)
	}

	func updatedConfigNoShouldUpdate(_ appVersion: String, minVersion: String = "1.0") {
		let updatedConfig = Config()
		updatedConfig.minVersion = minVersion
		updatedConfig.forceUpdate = true
		updatedConfig.otaUpdate = false
		updatedConfig.lastVersion = "1.0"
		self.configDataManagerMock.inUpdateConfigResponse = .success(config: updatedConfig, version: appVersion)
	}

	func updatedConfigForceUpdate(_ appVersion: String, minVersion: String = "2.0") {
		let updatedConfig = Config()
		updatedConfig.minVersion = minVersion
		updatedConfig.forceUpdate = true
		updatedConfig.otaUpdate = false
		updatedConfig.lastVersion = "2.0"
		self.configDataManagerMock.inUpdateConfigResponse = .success(config: updatedConfig, version: appVersion)
	}

	func currentConfigShouldForceUpdate(_ appVersion: String) {
		self.configDataManagerMock.stubVersion = appVersion
		self.configDataManagerMock.inCurrentConfig!.minVersion = "2.0"
		self.configDataManagerMock.inCurrentConfig!.forceUpdate = true
		self.configDataManagerMock.inCurrentConfig!.otaUpdate = true
		self.configDataManagerMock.inCurrentConfig!.lastVersion = "2.0"
	}

	func currentConfigNoForceUpdate(_ appVersion: String) {
		self.configDataManagerMock.stubVersion = appVersion
		self.configDataManagerMock.inCurrentConfig!.minVersion = "2.0"
		self.configDataManagerMock.inCurrentConfig!.forceUpdate = false
		self.configDataManagerMock.inCurrentConfig!.otaUpdate = false
		self.configDataManagerMock.inCurrentConfig!.lastVersion = "2.0"
	}

	func currentConfigNoShouldUpdate(_ appVersion: String) {
		self.configDataManagerMock.stubVersion = appVersion
		self.configDataManagerMock.inCurrentConfig!.minVersion = "1.0"
		self.configDataManagerMock.inCurrentConfig!.forceUpdate = true
		self.configDataManagerMock.inCurrentConfig!.otaUpdate = false
		self.configDataManagerMock.inCurrentConfig!.lastVersion = "2.0"
	}

	func currentConfigForceUpdate(_ appVersion: String) {
		self.configDataManagerMock.stubVersion = appVersion
		self.configDataManagerMock.inCurrentConfig!.minVersion = "2.0"
		self.configDataManagerMock.inCurrentConfig!.forceUpdate = true
		self.configDataManagerMock.inCurrentConfig!.otaUpdate = true
		self.configDataManagerMock.inCurrentConfig!.lastVersion = "2.0"
	}


	// OTA

	func updatedConfigNoOtaUpdate(_ appVersion: String) {
		let updatedConfig = Config()
		updatedConfig.minVersion = "2.0"
		updatedConfig.forceUpdate = false
		updatedConfig.otaUpdate = false
		updatedConfig.lastVersion = "2.0"
		self.configDataManagerMock.inUpdateConfigResponse = .success(config: updatedConfig, version: appVersion)
	}

	func updatedConfigOtaNoShouldUpdate(_ appVersion: String, lastVersion: String = "1.0") {
		let updatedConfig = Config()
		updatedConfig.minVersion = "2.0"
		updatedConfig.forceUpdate = false
		updatedConfig.otaUpdate = true
		updatedConfig.lastVersion = lastVersion
		self.configDataManagerMock.inUpdateConfigResponse = .success(config: updatedConfig, version: appVersion)
	}

	func updatedConfigOtaUpdate(_ appVersion: String) {
		let updatedConfig = Config()
		updatedConfig.minVersion = "2.0"
		updatedConfig.forceUpdate = false
		updatedConfig.otaUpdate = true
		updatedConfig.lastVersion = "2.0"
		self.configDataManagerMock.inUpdateConfigResponse = .success(config: updatedConfig, version: appVersion)
	}

	func currentConfigNoOtaUpdate(_ appVersion: String) {
		self.configDataManagerMock.stubVersion = appVersion
		self.configDataManagerMock.inCurrentConfig!.minVersion = "2.0"
		self.configDataManagerMock.inCurrentConfig!.forceUpdate = false
		self.configDataManagerMock.inCurrentConfig!.otaUpdate = false
		self.configDataManagerMock.inCurrentConfig!.lastVersion = "2.0"
	}

	func currentConfigOtaNoShouldUpdate(_ appVersion: String) {
		self.configDataManagerMock.stubVersion = appVersion
		self.configDataManagerMock.inCurrentConfig!.minVersion = "2.0"
		self.configDataManagerMock.inCurrentConfig!.forceUpdate = false
		self.configDataManagerMock.inCurrentConfig!.otaUpdate = true
		self.configDataManagerMock.inCurrentConfig!.lastVersion = "1.0"
	}

	func currentConfigOtaUpdate(_ appVersion: String) {
		self.configDataManagerMock.stubVersion = appVersion
		self.configDataManagerMock.inCurrentConfig!.minVersion = "1.0"
		self.configDataManagerMock.inCurrentConfig!.forceUpdate = false
		self.configDataManagerMock.inCurrentConfig!.otaUpdate = true
		self.configDataManagerMock.inCurrentConfig!.lastVersion = "2.0"
	}

}
