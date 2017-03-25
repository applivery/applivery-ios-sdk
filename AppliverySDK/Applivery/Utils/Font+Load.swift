//
//  Font+Load.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 16/1/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation

// Based on responses from: http://stackoverflow.com/questions/30507905/xcode-using-custom-fonts-inside-dynamic-framework

extension UIFont {

	internal static func loadAppliveryFont(_ filenameString: String) {
		// Workaround to Apple's bug: http://stackoverflow.com/questions/24900979/cgfontcreatewithdataprovider-hangs-in-airplane-mode
		_ = self.familyNames

		let bundle = Bundle.applivery()
		guard let pathForResourceString = bundle.path(forResource: filenameString, ofType: nil) else {
			return logWarn("UIFont+:  Failed to register font (\(filenameString)) - path for resource not found .")
		}

		guard let fontData = try? Data(contentsOf: URL(fileURLWithPath: pathForResourceString)) else {
			return logWarn("UIFont+:  Failed to register font (\(filenameString)) - font data could not be loaded.")
		}

		guard let dataProvider = CGDataProvider(data: fontData as CFData) else {
			return logWarn("UIFont+:  Failed to register font (\(filenameString)) - data provider could not be loaded.")
		}

		let fontRef = CGFont(dataProvider)

		var errorRef: Unmanaged<CFError>? = nil
		if CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) == false {
			logWarn("UIFont+:  Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
		}
	}

}
