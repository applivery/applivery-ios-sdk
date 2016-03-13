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
	
	private class func takeScreenshot() -> UIImage {
		let layer = UIApplication.sharedApplication().keyWindow!.layer
		let scale = UIScreen.mainScreen().scale
		UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
		
		layer.renderInContext(UIGraphicsGetCurrentContext()!)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return image
	}

	
	// MARK - Initializers
	
	private init(image: UIImage) {
		self.image = image
	}
	
	
	// MARK - Public Methods
	
	func base64() -> String? {
		let imageData = UIImagePNGRepresentation(self.image)
		let base64String = imageData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength) 
		
		return base64String
	}
	
}

