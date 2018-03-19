//
//  Print.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 12/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation


func >= (levelA: LogLevel, levelB: LogLevel) -> Bool {
	return levelA.rawValue >= levelB.rawValue
}


func log(_ log: String) {
	guard
		!GlobalConfig.shared.appStoreRelease
		&& GlobalConfig.shared.logLevel != .none
		else { return }

	print("Applivery :: " + log)
}

func logInfo(_ message: String) {
	guard GlobalConfig.shared.logLevel >= .info else { return }

	log(message)
}

func logWarn(_ message: String, filename: NSString = #file, line: Int = #line, funcname: String = #function) {
	guard GlobalConfig.shared.logLevel >= .error else { return }

	let caller = "\(filename.lastPathComponent)(\(line)) \(funcname)"
	log("🚸🚸🚸 WARNING: " + message)
	log("🚸🚸🚸 ⤷ FROM CALLER: " + caller + "\n")
}


func logError(_ error: NSError?, filename: NSString = #file, line: Int = #line, funcname: String = #function) {
	guard
		GlobalConfig.shared.logLevel >= .error,
		let err = error
		else { return }
	
	if let code = error?.code, code == 401 || code == 402 {
		log("Invalid credentials!! Please, check your ApiKey as described on https://github.com/applivery/applivery-ios-sdk#get-your-credentials")
		return
	}

	let caller = "\(filename.lastPathComponent)(\(line)) \(funcname)"
	log("❌❌❌ ERROR: " + err.localizedDescription)
	log("❌❌❌ ⤷ FROM CALLER: " + caller)
	log("❌❌❌ ⤷ USER INFO: \(err.userInfo)\n")
}
