//
//  ImageManager.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 5/3/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


class ImageManager {
	
	private var screenshot: Screenshot!
	
	func getScreenshot() -> Screenshot {
		self.screenshot = Screenshot.capture()
		
		return self.screenshot
	}
	
}