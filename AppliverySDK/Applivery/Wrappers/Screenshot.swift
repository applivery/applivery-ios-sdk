//
//  ScreenshotWrapper.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 5/3/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


struct Screenshot {

	var image: UIImage


	// MARK - Factory Methods

	static func capture() -> Screenshot {
		let image = Screenshot.takeScreenshot()
		let screenshot = Screenshot(image: image)

		return screenshot
	}

	private static func takeScreenshot() -> UIImage {
		let layer = UIApplication.shared.keyWindow!.layer
		let scale = UIScreen.main.scale
		UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)

		layer.render(in: UIGraphicsGetCurrentContext()!)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return image!
	}


	// MARK - Public Methods

	func base64() -> String? {
		let imageData = UIImageJPEGRepresentation(self.image, 0.9)
		let base64String = imageData?.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)

		return base64String
	}

}
