//
//  ScreenshotInteractor.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 5/3/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


class ScreenshotInteractor {
	
	private var imageManager = ImageManager()
	
	func getScreenshot() -> Screenshot {
		return self.imageManager.getScreenshot()
	}
	
}