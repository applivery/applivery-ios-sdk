//
//  ImageManagerMock.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 16/4/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import UIKit
@testable import Applivery


class ImageManagerMock: PImageManager {

	// INPUTS
	var fakeScreenshot: Screenshot!

	// OUTPUTS
	var spyGetScreenshotCalled = false


	func getScreenshot() -> Screenshot {
		self.spyGetScreenshotCalled = true

		return self.fakeScreenshot
	}

}
