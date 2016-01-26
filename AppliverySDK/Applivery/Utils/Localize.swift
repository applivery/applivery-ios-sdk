//
//  Localize.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 7/1/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation

func Localize(key: String) -> String {
	let literal = NSLocalizedString(key, tableName: nil, bundle: NSBundle.AppliveryBundle(), value: "", comment: "")

	return literal
}