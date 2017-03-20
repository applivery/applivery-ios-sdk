//
//  Palette.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez Agudo on 20/3/17.
//  Copyright © 2017 Applivery S.L. All rights reserved.
//

import Foundation

public class Palette: NSObject {
	public var primaryColor: UIColor
	public var secondaryColor: UIColor
	public var primaryFontColor: UIColor
	public var secondaryFontColor: UIColor
	public var screenshotBrushColor: UIColor
	
	// MARK: - Applivery's colors
	private static let appliveryPrimary			= #colorLiteral(red: 0.1137254902, green: 0.4392156863, blue: 0.7176470588, alpha: 1)
	private static let appliveryPrimaryFont		= #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
	private static let appliverySecondary		= #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
	private static let appliverySecondaryFont	= #colorLiteral(red: 0.2666666667, green: 0.2666666667, blue: 0.2666666667, alpha: 1)
	private static let appliveryScreenshotBrush = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
	
	public init(primaryColor: UIColor = Palette.appliveryPrimary,
	            secondaryColor: UIColor = Palette.appliveryPrimaryFont,
	            primaryFontColor: UIColor = Palette.appliverySecondary,
	            secondaryFontColor: UIColor = Palette.appliverySecondaryFont,
	            screenshotBrushColor: UIColor = Palette.appliveryScreenshotBrush) {
		self.primaryColor = primaryColor
		self.primaryFontColor = primaryFontColor
		self.secondaryColor = secondaryColor
		self.secondaryFontColor = secondaryFontColor
		self.screenshotBrushColor = screenshotBrushColor
	}
}
