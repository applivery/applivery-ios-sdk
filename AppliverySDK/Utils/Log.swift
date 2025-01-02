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
	print("Applivery :: " + log)
}

func sdkLog(_ message: @autoclosure () -> String, level: LogLevel, filename: NSString = #file, line: Int = #line, funcname: String = #function) {
    if let handler = GlobalConfig.shared.logHandler {
        handler(message() as NSString, level.rawValue, filename as String as NSString, line, funcname as NSString)
    }
}

func logInfo(_ message: String, filename: NSString = #file, line: Int = #line, funcname: String = #function)
{
    guard GlobalConfig.shared.logLevel >= .info else { return }
    sdkLog(message, level: .info, filename: filename, line: line, funcname: funcname)
}

func logWarn(_ message: String, filename: NSString = #file, line: Int = #line, funcname: String = #function) {
    guard GlobalConfig.shared.logLevel >= .error else { return }

    let caller = "\(filename.lastPathComponent)(\(line)) \(funcname)"
    let combinedMessage = """
    ⚠️⚠️⚠️ WARNING: \(message)
    ⚠️⚠️⚠️ ⤷ FROM CALLER: \(caller)
    """
    sdkLog(combinedMessage, level: .error, filename: filename, line: line, funcname: funcname)
}

func logError(_ error: NSError?, filename: NSString = #file, line: Int = #line, funcname: String = #function) {
    guard
        GlobalConfig.shared.logLevel >= .error,
        let err = error
    else {
        return
    }
    
    if let code = error?.code,
       code == 401 || code == 402 || code == 4002 {
        return
    }

    let caller = "\(filename.lastPathComponent)(\(line)) \(funcname)"
    let combinedMessage = """
    ‼️‼️‼️ ERROR: \(err.localizedDescription)
    ‼️‼️‼️ ⤷ FROM CALLER: \(caller)
    ‼️‼️‼️ ⤷ USER INFO: \(err.userInfo)
    """
    sdkLog(combinedMessage, level: .error, filename: filename, line: line, funcname: funcname)
}
