//
//  UpdatePresenterTests.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 8/12/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import XCTest
@testable import Applivery


class UpdatePresenterTests: XCTestCase {

	var presenter: UpdatePresenter!
	var updateViewMock: UpdateViewMock!
	var updateInteractorMock: UpdateInteractoMock!


    override func setUp() {
        super.setUp()

		self.updateViewMock = UpdateViewMock()
		self.updateInteractorMock = UpdateInteractoMock()

		self.presenter = UpdatePresenter(
			updateInteractor: self.updateInteractorMock,
			view: self.updateViewMock
		)
    }

    override func tearDown() {
		self.presenter = nil
		self.updateViewMock = nil
		self.updateInteractorMock = nil

        super.tearDown()
    }


    func test_not_nil() {
		XCTAssertNotNil(self.presenter)
    }

	func test_whenViewDidLoad_showUpdateMessage() {
		// Prepare
		self.updateInteractorMock.inForceUpdateMessage = "TEST_MESSAGE"

		// Run
		self.presenter.viewDidLoad()

		// Verify
		XCTAssert(self.updateViewMock.spyShowUpdateMessage.called == true)
		XCTAssert(self.updateViewMock.spyShowUpdateMessage.message == "TEST_MESSAGE")
	}

	func test_downloadDidEnd() {
		self.presenter.downloadDidEnd()

		XCTAssert(self.updateViewMock.spyStopLoadingCalled)
	}

	func test_downloadDidFail() {
		self.presenter.downloadDidFail("TEST")

		XCTAssert(self.updateViewMock.spyStopLoadingCalled == true)
		XCTAssert(self.updateViewMock.spyShowErrorMessage.called == true)
		XCTAssert(self.updateViewMock.spyShowErrorMessage.message == "TEST")
	}

}
