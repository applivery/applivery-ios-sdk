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
	var inScreenshot: Screenshot!

	// OUTPUTS
	var outGetScreenshotCalled = false


	func getScreenshot() -> Screenshot {
		self.outGetScreenshotCalled = true

		return self.inScreenshot
	}

}
