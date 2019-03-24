//
//  Palette.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez Agudo on 20/3/17.
//  Copyright © 2017 Applivery S.L. All rights reserved.
//

import Foundation

/**
A color palette for view's customization

# Overview
You can customize the SDK's colors by setting the properties of this class.

# Example

```swift
Applivery.shared.palette = Palette(
primaryColor: .orange,
secondaryColor: .white,
primaryFontColor: .white,
secondaryFontColor: .black,
screenshotBrushColor: .green
)
```

- seealso: `Applivery.palette`
- Since: 2.4
- Version: 2.7.2
- Author: Alejandro Jiménez Agudo
- Copyright: Applivery S.L.
*/
public class Palette: NSObject {
	
	// MARK: - Instance Properties
	
	/// Main color of your brand
	@objc public var primaryColor: UIColor
	
	/// Background color
	@objc public var secondaryColor: UIColor
	
	/// Primary font color. It should be in contrast with the primary color
	@objc public var primaryFontColor: UIColor
	
	/// Secondary font color. It should be in contrast with the secondary color
	@objc public var secondaryFontColor: UIColor
	
	/// Sets a color for the brush on screenshot edit mode
	@objc public var screenshotBrushColor: UIColor
	
	
	// MARK: - Initializer
	
	/**
	Creates a new instance of an Applivery's palette.
	
	- Parameters:
	- primaryColor: Main color of your brand
	- secondaryColor: Background color
	- primaryFontColor: Primary font color. It should be in contrast with the primary color
	- secondaryFontColor: Secondary font color. It should be in contrast with the secondary color
	- screenshotBrushColor: Sets a color for the brush on screenshot edit mode
	
	- Note: Each parameter has a default color, so you could set only the values that you really need to change
	- Since: 2.4
	- Version: 2.4
	*/
	@objc public init(primaryColor: UIColor = Colors.appliveryPrimary,
	                  secondaryColor: UIColor = Colors.appliveryPrimaryFont,
	                  primaryFontColor: UIColor = Colors.appliverySecondary,
	                  secondaryFontColor: UIColor = Colors.appliverySecondaryFont,
	                  screenshotBrushColor: UIColor = Colors.appliveryScreenshotBrush) {
		self.primaryColor = primaryColor
		self.primaryFontColor = primaryFontColor
		self.secondaryColor = secondaryColor
		self.secondaryFontColor = secondaryFontColor
		self.screenshotBrushColor = screenshotBrushColor
	}
}
