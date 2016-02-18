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
	
	// INPUTS
	var inDictionary: [String: AnyObject]?
	
	// OUTPUTS
	var outSyncedDictionary: [String: AnyObject]?
	
	
	private var tempDictionary = [String: AnyObject]()
	
	
	// MARK - Public Methods
	
	func valueForKey(key: String) -> AnyObject? {
		return self.inDictionary?[key]
	}
	
	func setValue(value: AnyObject?, forKey key: String) {
		self.tempDictionary[key] = value
	}
	
	func setBool(value: Bool, forKey key: String) {
		self.tempDictionary[key] = value
	}
	
	func synchronize() -> Bool {
		self.outSyncedDictionary = self.tempDictionary
		return true
	}
	
}