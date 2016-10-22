//
//  UIColor+Hex.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 13/3/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation

extension UIColor {

	class func FromHex(_ hex: Int) -> UIColor {
		return UIColor(
			colorLiteralRed: (Float)((hex & 0xFF0000) >> 16)/255.0,
			green: (Float)((hex & 0xFF00) >> 8)/255.0,
			blue: (Float)(hex & 0xFF)/255.0,
			alpha: 1
		)
	}
}
