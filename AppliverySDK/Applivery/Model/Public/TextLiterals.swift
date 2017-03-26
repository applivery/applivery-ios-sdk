//
//  TextLiterals.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez Agudo on 26/3/17.
//  Copyright © 2017 Applivery S.L. All rights reserved.
//

import Foundation

public class TextLiterals: NSObject {
	
	public var appName: String = localize("sdk_name")
	
}

enum Literal: CustomStringConvertible {
	case appName
	
	var description: String {
		return literal(self)
	}
}

func literal(_ literal: Literal) -> String {
	let literals = GlobalConfig.shared.textLiterals
	
	switch literal {
	case .appName: return literals.appName
	}
}
