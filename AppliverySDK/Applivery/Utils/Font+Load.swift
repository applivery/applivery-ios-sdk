//
//  Font+Load.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 16/1/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation

// Based on responses from: http://stackoverflow.com/questions/30507905/xcode-using-custom-fonts-inside-dynamic-framework

extension UIFont
{
	internal static func loadAppliveryFont(filenameString: String)
	{
		// Workaround to Apple's bug: http://stackoverflow.com/questions/24900979/cgfontcreatewithdataprovider-hangs-in-airplane-mode
		self.familyNames()
		
		let bundle = NSBundle.AppliveryBundle()
		guard let pathForResourceString = bundle.pathForResource(filenameString, ofType: "ttf") else {
			return LogWarn("UIFont+:  Failed to register font - path for resource not found.")
		}
		
		guard let fontData = NSData(contentsOfFile: pathForResourceString) else	{
			return LogWarn("UIFont+:  Failed to register font - font data could not be loaded.")
		}
		
		guard let dataProvider = CGDataProviderCreateWithCFData(fontData) else {
			return LogWarn("UIFont+:  Failed to register font - data provider could not be loaded.")
		}
		
		let fontRef = CGFontCreateWithDataProvider(dataProvider)
		
		var errorRef: Unmanaged<CFError>? = nil
		if (CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) == false)
		{
			LogWarn("UIFont+:  Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
		}
	}
}
