//
//  Print.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 12/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation


public func >=(levelA: LogLevel, levelB: LogLevel) -> Bool {
	return levelA.rawValue >= levelB.rawValue
}


func Log(_ log: String) {
	guard
		!GlobalConfig.shared.appStoreRelease
		&& GlobalConfig.shared.logLevel != .none
		else { return }
	
	print("Applivery :: " + log)
}

func LogInfo(_ log: String) {
	guard GlobalConfig.shared.logLevel >= .info else { return }

	Log(log)
}

func LogWarn(_ message: String, filename: NSString = #file, line: Int = #line, funcname: String = #function) {
	guard GlobalConfig.shared.logLevel >= .error else { return }
	
	let caller = "\(filename.lastPathComponent)(\(line)) \(funcname)"
	Log("🚸🚸🚸 WARNING: " + message)
	Log("🚸🚸🚸 ⤷ FROM CALLER: " + caller + "\n")
}


func LogError(_ error: NSError?, filename: NSString = #file, line: Int = #line, funcname: String = #function) {
	guard
		GlobalConfig.shared.logLevel >= .error,
		let err = error
		else { return }
	
	let caller = "\(filename.lastPathComponent)(\(line)) \(funcname)"
	Log("❌❌❌ ERROR: " + err.localizedDescription)
	Log("❌❌❌ ⤷ FROM CALLER: " + caller)
	Log("❌❌❌ ⤷ USER INFO: \(err.userInfo)\n")
}
