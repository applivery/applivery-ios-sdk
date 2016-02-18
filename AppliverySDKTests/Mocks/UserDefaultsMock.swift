//
//  UserDefaultsMock.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 18/2/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation
@testable import Applivery


class UserDefaultsMock: UserDefaults {
	
	var inDictionary: [String: AnyObject]?
	
	func valueForKey(key: String) -> AnyObject? {
		return self.inDictionary?[key]
	}
	
}