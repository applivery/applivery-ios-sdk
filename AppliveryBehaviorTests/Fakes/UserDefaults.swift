//
//  UserDefaults.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez Agudo on 2/4/17.
//  Copyright © 2017 Applivery S.L. All rights reserved.
//

import Foundation
import Nimble
@testable import Applivery

class UserDefaultFakes {
	
	class func jsonConfigSuccess() -> [String: Any] {
		let dictionary: [String: Any] = [
			kMinVersionKey: "10",
			kForceUpdateKey: true,
			kLastBuildId: "58d954995551fb411450f4d2",
			kForceUpdateMessageKey: "Sorry, you must update the App to the latest version to continue.",
			kOtaUpdateKey: true,
			kLastBuildVersion: "35",
			kOtaUpdateMessageKey: "There is a new version available for download! Do you want to update to the latest version?",
			kForceAuth: false
		]
		
		return dictionary
	}
	
	class func storedConfig(lastBuildID: String? = nil, forceAuth: Bool = false, accessToken: AccessToken? = nil) -> [String: Any] {
		let dictionary: [String: Any] = [
			kMinVersionKey: "15",
			kForceUpdateKey: true,
			kLastBuildId: lastBuildID ?? "58d954995551fb411450f4d2",
			kForceUpdateMessageKey: "Sorry, you must update the App to the latest version to continue.",
			kOtaUpdateKey: true,
			kLastBuildVersion: "50",
			kOtaUpdateMessageKey: "There is a new version available for download! Do you want to update to the latest version?",
			kForceAuth: forceAuth,
			kAccessTokenKey: accessToken as Any
		]
		
		return dictionary
	}
	
}

//func equal(_ expectedDictionary: [String: Any]?) -> Predicate<[String: Any]?> {
//	return Predicate.define("equal <\(String(describing: expectedDictionary))>") { actualExpression, msg -> PredicateResult in
//		if let actualValue = try actualExpression.evaluate() {
//			guard let actualValueDict = actualValue else { return PredicateResult(bool: false, message: msg) }
//			guard let expectedDictionaryDict = expectedDictionary else { return PredicateResult(bool: false, message: msg) }
//			
//			let matches = NSDictionary(dictionary: actualValueDict).isEqual(to: expectedDictionaryDict)
//			return PredicateResult(bool: matches, message: msg)
//		} else {
//			return PredicateResult(bool: false, message: msg)
//		}
//		
//	}
//}
