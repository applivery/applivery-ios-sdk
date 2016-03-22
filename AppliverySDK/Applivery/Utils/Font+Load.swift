//
//  Font+Load.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 16/1/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


// From: http://stackoverflow.com/questions/30507905/xcode-using-custom-fonts-inside-dynamic-framework

extension UIFont
{
	internal static func registerFontWithFilenameString(filenameString: String, bundle: NSBundle)
	{
		// Workaround to Apple's bug: http://stackoverflow.com/questions/24900979/cgfontcreatewithdataprovider-hangs-in-airplane-mode
		self.familyNames()
		
		if let pathForResourceString = bundle.pathForResource(filenameString, ofType: nil)
		{
			if let fontData = NSData(contentsOfFile: pathForResourceString)
			{
				if let dataProvider = CGDataProviderCreateWithCFData(fontData)
				{
					if let fontRef = CGFontCreateWithDataProvider(dataProvider)
					{
						var errorRef: Unmanaged<CFError>? = nil
						
						if (CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) == false)
						{
							LogWarn("UIFont+:  Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
						}
					}
					else
					{
						LogWarn("UIFont+:  Failed to register font - font could not be loaded.")
					}
				}
				else
				{
					LogWarn("UIFont+:  Failed to register font - data provider could not be loaded.")
				}
			}
			else
			{
				LogWarn("UIFont+:  Failed to register font - font data could not be loaded.")
			}
		}
		else
		{
			LogWarn("UIFont+:  Failed to register font - path for resource not found.")
		}
	}
}
