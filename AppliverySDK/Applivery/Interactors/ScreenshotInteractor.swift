//
//  ScreenshotInteractor.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 5/3/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


protocol PScreenshotInteractor {
	func getScreenshot() -> Screenshot
}


class ScreenshotInteractor: PScreenshotInteractor {

	fileprivate var imageManager: PImageManager

	init(imageManager: PImageManager = ImageManager()) {
		self.imageManager = imageManager
	}

	func getScreenshot() -> Screenshot {
		return self.imageManager.getScreenshot()
	}

}
