//
//  UserDefaultsMock.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 18/2/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation
@testable import Applivery


class UserDefaultsMock: UserDefaultsProtocol {

	// INPUTS
	var stubDictionary: [String: Any]?

	// OUTPUTS
	var spyDictionary: [String: Any]?
	var spySynchronizeCalled = false


	fileprivate var tempDictionary = [String: Any]()


	// MARK - Public Methods

	func value(forKey key: String) -> Any? {
		return self.stubDictionary?[key]
	}

	func setValue(_ value: Any?, forKey key: String) {
		self.tempDictionary[key] = value
	}

	func set(_ value: Bool, forKey key: String) {
		self.tempDictionary[key] = value as AnyObject?
	}

	func synchronize() -> Bool {
		self.spySynchronizeCalled = true
		self.spyDictionary = self.tempDictionary
		return true
	}

}
