//
//  UpdateInteractorTests.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 19/12/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import XCTest
@testable import Applivery


class UpdateInteractorTests: XCTestCase {
	
	var updateInteractor: UpdateInteractor!
	var configDataManagerMock: ConfigDataManagerMock!
	var downloadDataManagerMock: DownloadDataManagerMock!
	var appMock: AppMock!
	var updateInteractorOutputMock: UpdateInteractorOutputMock!
	
	
	override func setUp() {
		super.setUp()
		
		self.updateInteractorOutputMock = UpdateInteractorOutputMock()
		self.appMock = AppMock()
		self.downloadDataManagerMock = DownloadDataManagerMock()
		self.configDataManagerMock = ConfigDataManagerMock()
		
		self.updateInteractor = UpdateInteractor(
			output: nil,
			configData: self.configDataManagerMock,
			downloadData: self.downloadDataManagerMock,
			app: self.appMock,
			loginInteractor: LoginInteractor(
				app: self.appMock,
				loginService: LoginService(),
				globalConfig: GlobalConfig(),
				sessionPersister: SessionPersister(
					userDefaults: UserDefaults()
				)
			),
			globalConfig: GlobalConfig()
		)
		self.updateInteractor.output = self.updateInteractorOutputMock
	}
	
	override func tearDown() {
		self.updateInteractor = nil
		self.configDataManagerMock = nil
		self.downloadDataManagerMock = nil
		self.appMock = nil
		self.updateInteractorOutputMock = nil
		
		super.tearDown()
	}
	
	
	func test_not_nil() {
		XCTAssertNotNil(self.updateInteractor)
	}
	
	
	// MARK: - Force update message tests
	
	func test_nil_config_returns_default_message() {
		self.configDataManagerMock.inCurrentConfig = nil
		
		let message = self.updateInteractor.forceUpdateMessage()
		
		XCTAssert(message == localize("force_update_message"))
	}
	
	func test_nil_message_returns_default_message() {
		self.configDataManagerMock.inCurrentConfig = Config()
		self.configDataManagerMock.inCurrentConfig!.forceUpdateMessage = nil
		
		let message = self.updateInteractor.forceUpdateMessage()
		
		XCTAssert(message == localize("force_update_message"))
	}
	
	func test_empty_message_returns_default_message() {
		self.configDataManagerMock.inCurrentConfig = Config()
		self.configDataManagerMock.inCurrentConfig!.forceUpdateMessage = ""
		
		let message = self.updateInteractor.forceUpdateMessage()
		
		XCTAssert(message == localize("force_update_message"))
	}
	
	func test_success_message_returns_message() {
		self.configDataManagerMock.inCurrentConfig = Config()
		self.configDataManagerMock.inCurrentConfig!.forceUpdateMessage = "TEST MESSAGE"
		
		let message = self.updateInteractor.forceUpdateMessage()
		
		XCTAssert(message == "TEST MESSAGE")
	}
	
	func test_forceUpdateMessage_returnsDeveloperMessage_whenDeveloperMessageIsSet() {
		self.configDataManagerMock.inCurrentConfig = Config()
		self.configDataManagerMock.inCurrentConfig!.forceUpdateMessage = "TEST MESSAGE"
		Applivery.shared.textLiterals.forceUpdateMessage = "DEVELOPER MESSAGE"
		
		let message = self.updateInteractor.forceUpdateMessage()
		
		XCTAssert(message == "DEVELOPER MESSAGE")
		Applivery.shared.textLiterals.forceUpdateMessage = nil
	}
	
	// MARK: - OTA Update Message Tests
	
	func test_otaMessage_returnsDefaultMessage_whenUpdateMessageIsNil() {
		self.configDataManagerMock.inCurrentConfig = nil
		
		let message = self.updateInteractor.otaUpdateMessage()
		
		XCTAssert(message == localize("ota_update_message"))
	}
	
	func test_otaMessage_returnsDefaultMessage_whenConfigIsNil() {
		self.configDataManagerMock.inCurrentConfig = Config()
		self.configDataManagerMock.inCurrentConfig!.forceUpdateMessage = nil
		
		let message = self.updateInteractor.otaUpdateMessage()
		
		XCTAssert(message == localize("ota_update_message"))
	}
	
	func test_otaMessage_returnsDefaultMessage_whenUpdateMessageIsEmpty() {
		self.configDataManagerMock.inCurrentConfig = Config()
		self.configDataManagerMock.inCurrentConfig!.otaUpdateMessage = ""
		
		let message = self.updateInteractor.otaUpdateMessage()
		
		XCTAssert(message == localize("ota_update_message"))
	}
	
	func test_otaMessage_returnsServerMessage_whenUpdateMessageIsSettedByServer() {
		self.configDataManagerMock.inCurrentConfig = Config()
		self.configDataManagerMock.inCurrentConfig!.otaUpdateMessage = "TEST MESSAGE"
		
		let message = self.updateInteractor.otaUpdateMessage()
		
		XCTAssert(message == "TEST MESSAGE")
	}
	
	func test_otaMessage_returnsDeveloperMessage_whenUpdateMessageIsSettedByUser() {
		self.configDataManagerMock.inCurrentConfig = Config()
		self.configDataManagerMock.inCurrentConfig!.otaUpdateMessage = "TEST MESSAGE"
		Applivery.shared.textLiterals.otaUpdateMessage = "DEVELOPER MESSAGE"
		
		let message = self.updateInteractor.otaUpdateMessage()
		
		XCTAssert(message == "DEVELOPER MESSAGE")
		
		// Clear singleton literal
		Applivery.shared.textLiterals.otaUpdateMessage = nil
	}
	
	
	// MARK: - Download Last Build Tests
	
	func test_downloadBuild_success() {
		self.configDataManagerMock.inCurrentConfig = Config()
		self.configDataManagerMock.inCurrentConfig?.lastBuildId = "123456"
		self.downloadDataManagerMock.inDownloadResponse = DownloadUrlResponse.success(url: "url_test")
		self.appMock.stubOpenUrlResult = true
		
		self.updateInteractor.downloadLasBuild()
		
		XCTAssert(self.downloadDataManagerMock.outDownloadUrl.called == true)
		XCTAssert(self.downloadDataManagerMock.outDownloadUrl.lastBuildId == "123456")
		XCTAssert(self.appMock.spyOpenUrl.called == true)
		XCTAssert(self.appMock.spyOpenUrl.url == "url_test")
		XCTAssert(self.updateInteractorOutputMock.spyDownloadDidEndCalled == true)
		XCTAssert(self.updateInteractorOutputMock.spyDownloadDidFail.called == false)
	}
	
	func test_downloadBuild_fails_whenCanNotOpenUrl() {
		self.configDataManagerMock.inCurrentConfig = Config()
		self.configDataManagerMock.inCurrentConfig?.lastBuildId = "123456"
		self.downloadDataManagerMock.inDownloadResponse = DownloadUrlResponse.success(url: "url_test")
		self.appMock.stubOpenUrlResult = false
		
		self.updateInteractor.downloadLasBuild()
		
		XCTAssert(self.downloadDataManagerMock.outDownloadUrl.called == true)
		XCTAssert(self.downloadDataManagerMock.outDownloadUrl.lastBuildId == "123456")
		XCTAssert(self.appMock.spyOpenUrl.called == true)
		XCTAssert(self.appMock.spyOpenUrl.url == "url_test")
		XCTAssert(self.updateInteractorOutputMock.spyDownloadDidEndCalled == false)
		XCTAssert(self.updateInteractorOutputMock.spyDownloadDidFail.called == true)
		XCTAssert(self.updateInteractorOutputMock.spyDownloadDidFail.message == literal(.errorDownloadURL))
	}
	
	
	func test_downloadBuild_nilConfig_returnsFail() {
		self.updateInteractor.downloadLasBuild()
		
		XCTAssert(self.downloadDataManagerMock.outDownloadUrl.called == false)
		XCTAssert(self.appMock.spyOpenUrl.called == false)
		XCTAssert(self.updateInteractorOutputMock.spyDownloadDidEndCalled == false)
		XCTAssert(self.updateInteractorOutputMock.spyDownloadDidFail.called == true)
		XCTAssert(self.updateInteractorOutputMock.spyDownloadDidFail.message == literal(.errorUnexpected))
	}
	
	func test_downloadBuild_downloadDataFails_returnsFail() {
		self.configDataManagerMock.inCurrentConfig = Config()
		self.configDataManagerMock.inCurrentConfig?.lastBuildId = "123456"
		self.downloadDataManagerMock.inDownloadResponse = DownloadUrlResponse.error(message: "test_message")
		
		self.updateInteractor.downloadLasBuild()
		
		XCTAssert(self.downloadDataManagerMock.outDownloadUrl.called == true)
		XCTAssert(self.downloadDataManagerMock.outDownloadUrl.lastBuildId == "123456")
		XCTAssert(self.appMock.spyOpenUrl.called == false)
		XCTAssert(self.updateInteractorOutputMock.spyDownloadDidEndCalled == false)
		XCTAssert(self.updateInteractorOutputMock.spyDownloadDidFail.called == true)
		XCTAssert(self.updateInteractorOutputMock.spyDownloadDidFail.message == "test_message")
	}
	
}
