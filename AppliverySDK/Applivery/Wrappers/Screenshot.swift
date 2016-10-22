//
//  ScreenshotWrapper.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 5/3/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


class Screenshot {

	var image: UIImage


	// MARK - Factory Methods

	class func capture() -> Screenshot {
		let image = Screenshot.takeScreenshot()
		let screenshot = Screenshot(image: image)

		return screenshot
	}

	fileprivate class func takeScreenshot() -> UIImage {
		let layer = UIApplication.shared.keyWindow!.layer
		let scale = UIScreen.main.scale
		UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)

		layer.render(in: UIGraphicsGetCurrentContext()!)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return image!
	}


	// MARK - Initializers

	init(image: UIImage) {
		self.image = image
	}


	// MARK - Public Methods

	func base64() -> String? {
		let imageData = UIImagePNGRepresentation(self.image)
		let base64String = imageData?.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)

		return base64String
	}

}
