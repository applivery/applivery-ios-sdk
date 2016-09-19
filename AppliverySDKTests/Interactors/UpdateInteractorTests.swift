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
			configData: self.configDataManagerMock,
			downloadData: self.downloadDataManagerMock,
			app: self.appMock
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
	
	
	// MARK - Force update message tests
	
	func test_nil_config_returns_default_message() {
		self.configDataManagerMock.inCurrentConfig = nil
		
		let message = self.updateInteractor.forceUpdateMessage()
		
		XCTAssert(message == GlobalConfig.DefaultForceUpdateMessage)
	}
	
	func test_nil_message_returns_default_message() {
		self.configDataManagerMock.inCurrentConfig = Config()
		self.configDataManagerMock.inCurrentConfig!.forceUpdateMessage = nil
		
		let message = self.updateInteractor.forceUpdateMessage()
		
		XCTAssert(message == GlobalConfig.DefaultForceUpdateMessage)
	}
	
	func test_empty_message_returns_default_message() {
		self.configDataManagerMock.inCurrentConfig = Config()
		self.configDataManagerMock.inCurrentConfig!.forceUpdateMessage = ""
		
		let message = self.updateInteractor.forceUpdateMessage()
		
		XCTAssert(message == GlobalConfig.DefaultForceUpdateMessage)
	}
	
	func test_succes_message_returns_message() {
		self.configDataManagerMock.inCurrentConfig = Config()
		self.configDataManagerMock.inCurrentConfig!.forceUpdateMessage = "TEST MESSAGE"
		
		let message = self.updateInteractor.forceUpdateMessage()
		
		XCTAssert(message == "TEST MESSAGE")
	}
	
	
	// MARK - OTA Update Message Tests
	
	func test_otaMessage_returnsDefaultMessage_whenUpdateMessageIsNil() {
		self.configDataManagerMock.inCurrentConfig = nil
		
		let message = self.updateInteractor.otaUpdateMessage()
		
		XCTAssert(message == GlobalConfig.DefaultOtaUpdateMessage)
	}
	
	func test_otaMessage_returnsDefaultMessage_whenConfigIsNil() {
		self.configDataManagerMock.inCurrentConfig = Config()
		self.configDataManagerMock.inCurrentConfig!.forceUpdateMessage = nil
		
		let message = self.updateInteractor.otaUpdateMessage()
		
		XCTAssert(message == GlobalConfig.DefaultOtaUpdateMessage)
	}
	
	func test_otaMessage_returnsDefaultMessage_whenUpdateMessageIsEmpty() {
		self.configDataManagerMock.inCurrentConfig = Config()
		self.configDataManagerMock.inCurrentConfig!.otaUpdateMessage = ""
		
		let message = self.updateInteractor.otaUpdateMessage()
		
		XCTAssert(message == GlobalConfig.DefaultOtaUpdateMessage)
	}
	
	func test_otaMessage_returnsMessage_whenUpdateMessageIsSetted() {
		self.configDataManagerMock.inCurrentConfig = Config()
		self.configDataManagerMock.inCurrentConfig!.otaUpdateMessage = "TEST MESSAGE"
		
		let message = self.updateInteractor.otaUpdateMessage()
		
		XCTAssert(message == "TEST MESSAGE")
	}
	
	
	// MARK - Download Last Build Tests
	
	func test_downloadBuild_success() {
		self.configDataManagerMock.inCurrentConfig = Config()
		self.configDataManagerMock.inCurrentConfig?.lastBuildId = "123456"
		self.downloadDataManagerMock.inDownloadResponse = DownloadUrlResponse.success(url: "url_test")
		self.appMock.inOpenUrlResult = true
		
		self.updateInteractor.downloadLastBuild()
		
		XCTAssert(self.downloadDataManagerMock.outDownloadUrl.called == true)
		XCTAssert(self.downloadDataManagerMock.outDownloadUrl.lastBuildId == "123456")
		XCTAssert(self.appMock.outOpenUrl.called == true)
		XCTAssert(self.appMock.outOpenUrl.url == "url_test")
		XCTAssert(self.updateInteractorOutputMock.outDownloadDidEndCalled == true)
		XCTAssert(self.updateInteractorOutputMock.outDownloadDidFail.called == false)
	}
	
	func test_downloadBuild_fails_whenCanNotOpenUrl() {
		self.configDataManagerMock.inCurrentConfig = Config()
		self.configDataManagerMock.inCurrentConfig?.lastBuildId = "123456"
		self.downloadDataManagerMock.inDownloadResponse = DownloadUrlResponse.success(url: "url_test")
		self.appMock.inOpenUrlResult = false
		
		self.updateInteractor.downloadLastBuild()
		
		XCTAssert(self.downloadDataManagerMock.outDownloadUrl.called == true)
		XCTAssert(self.downloadDataManagerMock.outDownloadUrl.lastBuildId == "123456")
		XCTAssert(self.appMock.outOpenUrl.called == true)
		XCTAssert(self.appMock.outOpenUrl.url == "url_test")
		XCTAssert(self.updateInteractorOutputMock.outDownloadDidEndCalled == false)
		XCTAssert(self.updateInteractorOutputMock.outDownloadDidFail.called == true)
		XCTAssert(self.updateInteractorOutputMock.outDownloadDidFail.message == Localize("error_download_url"))
	}

	
	func test_downloadBuild_nilConfig_returnsFail() {
		self.updateInteractor.downloadLastBuild()
		
		XCTAssert(self.downloadDataManagerMock.outDownloadUrl.called == false)
		XCTAssert(self.appMock.outOpenUrl.called == false)
		XCTAssert(self.updateInteractorOutputMock.outDownloadDidEndCalled == false)
		XCTAssert(self.updateInteractorOutputMock.outDownloadDidFail.called == true)
		XCTAssert(self.updateInteractorOutputMock.outDownloadDidFail.message == Localize("error_unexpected"))
	}
	
	func test_downloadBuild_downloadDataFails_returnsFail() {
		self.configDataManagerMock.inCurrentConfig = Config()
		self.configDataManagerMock.inCurrentConfig?.lastBuildId = "123456"
		self.downloadDataManagerMock.inDownloadResponse = DownloadUrlResponse.error(message: "test_message")
		
		self.updateInteractor.downloadLastBuild()
		
		XCTAssert(self.downloadDataManagerMock.outDownloadUrl.called == true)
		XCTAssert(self.downloadDataManagerMock.outDownloadUrl.lastBuildId == "123456")
		XCTAssert(self.appMock.outOpenUrl.called == false)
		XCTAssert(self.updateInteractorOutputMock.outDownloadDidEndCalled == false)
		XCTAssert(self.updateInteractorOutputMock.outDownloadDidFail.called == true)
		XCTAssert(self.updateInteractorOutputMock.outDownloadDidFail.message == "test_message")
	}
	
}
