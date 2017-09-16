//
//  ScreenshotInteractorTests.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 16/4/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import XCTest
@testable import Applivery


class ScreenshotInteractorTests: XCTestCase {

	var screenshotInteractor: ScreenshotInteractor!
	var imageManagerMock: ImageManagerMock!


    override func setUp() {
        super.setUp()

		self.imageManagerMock = ImageManagerMock()
		self.screenshotInteractor = ScreenshotInteractor(imageManager: self.imageManagerMock)
    }

    override func tearDown() {
        self.screenshotInteractor = nil

        super.tearDown()
    }

    func test_not_nil() {
		XCTAssertNotNil(self.screenshotInteractor)
    }

	func test_getScreenshot_returnsScreenshot_whenManagerReturnScreenshot() {
		let inputScreenshot = Screenshot(image: UIImage())
		self.imageManagerMock.fakeScreenshot = inputScreenshot

		let resultScreenshot = self.screenshotInteractor.getScreenshot()

		XCTAssert(resultScreenshot == inputScreenshot)
		XCTAssert(self.imageManagerMock.spyGetScreenshotCalled == true)
	}
}


func == (left: Screenshot, right: Screenshot) -> Bool {
	return left.image == right.image
}
