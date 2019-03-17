//
//  Layout.swift
//  Applivery
//
//  Created by Alejandro Jiménez Agudo on 13/03/2019.
//  Copyright © 2019 Applivery S.L. All rights reserved.
//

import Foundation

struct Layout {
	
	static func safeAreaButtomHeight() -> CGFloat {
		var height: CGFloat = 0
		if #available(iOS 11.0, *) {
			height = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
		}
		
		return height
	}
	
}
