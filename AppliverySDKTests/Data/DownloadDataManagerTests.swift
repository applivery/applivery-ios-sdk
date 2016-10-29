//
//  DownloadDataManagerTests.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 7/1/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import XCTest
@testable import Applivery


func == (left: DownloadUrlResponse, right: DownloadUrlResponse) -> Bool {
	switch (left, right) {
	case (.success(let urlLeft),	.success(let urlRight))		where urlLeft == urlRight:			return true
	case (.error(let messageLeft),	.error(let messageRight))	where messageLeft == messageRight:	return true

	default: return false
	}
}


class DownloadDataManagerTests: XCTestCase {

	var downloadData: DownloadDataManager!
	var downloadServiceMock: DownloadServiceMock!


    override func setUp() {
        super.setUp()

		self.downloadServiceMock = DownloadServiceMock()
		self.downloadData = DownloadDataManager(service: self.downloadServiceMock)
    }

    override func tearDown() {
		self.downloadData = nil
		self.downloadServiceMock = nil

        super.tearDown()
    }

    func test_notNil() {
		XCTAssertNotNil(self.downloadData)
    }


	func test_downloadUrl_success() {
		self.downloadServiceMock.inDownloadTokenResponse = .success("test_token")

		var completionCalled = false
		self.downloadData.downloadUrl("test_build_id") { response in
			completionCalled = true

			let itms_service = "itms-services://?action=download-manifest&url="
			XCTAssert(response == .success(url: "\(itms_service)\(GlobalConfig.Host)/download/test_build_id/manifest/test_token"))
		}

		XCTAssert(completionCalled == true)
		XCTAssert(self.downloadServiceMock.outFetchDownloadToken.called == true)
		XCTAssert(self.downloadServiceMock.outFetchDownloadToken.buildId == "test_build_id")
	}

	func test_downloadUrl_networkError_returnsFail() {
		self.downloadServiceMock.inDownloadTokenResponse = .error(self.networkError())

		var completionCalled = false
		self.downloadData.downloadUrl("test_build_id") { response in
			completionCalled = true

			XCTAssert(response == .error(message: "error message"))
		}

		XCTAssert(completionCalled == true)
		XCTAssert(self.downloadServiceMock.outFetchDownloadToken.called == true)
		XCTAssert(self.downloadServiceMock.outFetchDownloadToken.buildId == "test_build_id")
	}

	func test_downloadUrl_networkErrorWithoutMessage_returnsFail() {
		self.downloadServiceMock.inDownloadTokenResponse = .error(self.networkErrorNoMessage())

		var completionCalled = false
		self.downloadData.downloadUrl("test_build_id") { response in
			completionCalled = true

			XCTAssert(response == .error(message: Localize("error_unexpected")))
		}

		XCTAssert(completionCalled == true)
		XCTAssert(self.downloadServiceMock.outFetchDownloadToken.called == true)
		XCTAssert(self.downloadServiceMock.outFetchDownloadToken.buildId == "test_build_id")
	}


	// MARK - Helpers

	func networkError() -> NSError {
		let error = NSError(
			domain: "com.test.error",
			code: -1,
			userInfo: [GlobalConfig.AppliveryErrorKey: "error message"]
		)

		return error
	}

	func networkErrorNoMessage() -> NSError {
		let error = NSError(
			domain: "com.test.error",
			code: -1,
			userInfo: nil
		)

		return error
	}

}
