//
//  Localize.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 7/1/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation

func localize(_ key: String) -> String {
	let literal = NSLocalizedString(key, tableName: nil, bundle: Bundle.applivery(), value: "", comment: "")

	return literal
}
