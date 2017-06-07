//
//  UpdateCoordinatorTests.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 23/1/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import XCTest
@testable import Applivery


class UpdateCoordinatorTests: XCTestCase {

	var updateCoordinator: UpdateCoordinator!
	var updateInteractorMock: UpdateInteractoMock!
	var appMock: AppMock!


    override func setUp() {
        super.setUp()

		self.updateInteractorMock = UpdateInteractoMock()
		self.appMock = AppMock()
		self.updateCoordinator = UpdateCoordinator(
			updateInteractor: self.updateInteractorMock,
			app: self.appMock
		)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_not_nil() {
		XCTAssertNotNil(self.updateCoordinator)
    }


	// MARK: - OTA Update

	func test_otaUpdate_appShowOtaAlert() {
		self.updateInteractorMock.inOtaUpdateMessage = "UPDATE MESSAGE"

		self.updateCoordinator.otaUpdate()

		XCTAssert(self.appMock.spyOtaAlert.called == true)
		XCTAssert(self.appMock.spyOtaAlert.message == "UPDATE MESSAGE")
		XCTAssert(self.appMock.spyWaitForReadyCalled == true)
	}

	func test_otaUpdate_showLoading_andDownloadBuild_whenUserTapsDownload() {
		let downloadClosure = self.otaDownloadClosure()

		downloadClosure()

		XCTAssert(self.appMock.spyShowLoadingCalled == true)
		XCTAssert(self.updateInteractorMock.outDownloadLastBuildCalled == true)
	}

	func test_otaUpdate_hideLoading_whenDownloadDidEnd() {
		self.updateCoordinator.downloadDidEnd()

		XCTAssert(self.appMock.spyHideLoadingCalled == true)
	}

	func test_otaUpdate_hideLoading_andShowAlertError_whenDownloadDidFail() {
		self.updateCoordinator.downloadDidFail("TEST MESSAGE")

		XCTAssert(self.appMock.spyHideLoadingCalled == true)
		XCTAssert(self.appMock.spyAlertError.called == true)
		XCTAssert(self.appMock.spyAlertError.message == "TEST MESSAGE")
	}

	func test_otaUpdate_showLoading_andDownloadBuild_whenUserTapsRetry() {
		let retryClosure = self.otaRetryClosure()

		retryClosure()

		XCTAssert(self.appMock.spyShowLoadingCalled == true)
		XCTAssert(self.updateInteractorMock.outDownloadLastBuildCalled == true)
	}


	// MARK: - Private Helpers

	func otaDownloadClosure() -> (() -> Void) {
		self.updateInteractorMock.inOtaUpdateMessage = "UPDATE MESSAGE"
		self.updateCoordinator.otaUpdate()

		return self.appMock.spyDownloadClosure!
	}

	func otaRetryClosure() -> (() -> Void) {
		self.updateCoordinator.downloadDidFail("")

		return self.appMock.spyRetryClosure!
	}

}
