//
//  ListHelper.swift
//  Applivery
//
//  Created by Alejandro Jiménez Agudo on 21/01/2020.
//  Copyright © 2020 Applivery S.L. All rights reserved.
//

import Foundation

internal func removeEmpty(_ value: String) -> String? {
	value.isEmpty ? nil : value
}
