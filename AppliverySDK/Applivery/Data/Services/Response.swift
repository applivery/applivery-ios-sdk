//
//  Response.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 12/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation


class Response {
	
	var success = false
	var url: NSURL?
	var code: Int
	var error: NSError?
	var body: JSON?
	var data: NSData?
	var headers: [String: String]?
	
	private let UnexpectedErrorJson = "Unexpected error trying to parse Json"
	private let InvalidCredentials = "Invalid credentials"
	
	
	init(data: NSData?, response: NSURLResponse?, error: NSError?) {
		self.data = data
		self.code = -1
		
		if let response = response as? NSHTTPURLResponse {
			self.url = response.URL
			self.headers = response.allHeaderFields as? [String: String]
			
			if response.statusCode == 200 {
				responseOK(data)
			}
			else {
				self.success = false
				self.code = response.statusCode
				self.parseError(error)
			}
		}
		else {
			self.error = error ?? NSError.UnexpectedError()
			self.code = self.error!.code
		}
		
		self.logResponse()
	}
	
	
	// MARK: Private Helpers
	private func responseOK(data: NSData?) {
		do {
			guard data != nil else {
				throw NSError.UnexpectedError("data is nil")
			}
			
			let json = try JSON.dataToJson(data!)
			
			guard let status = json["status"]?.toBool() else {
				throw NSError.UnexpectedError(self.UnexpectedErrorJson)
			}
			
			self.success = status
			if self.success {
				self.code = 200
				self.body = json["response"]
			}
			else {
				self.code = json["error.code"]?.toInt() ?? -1
				
				let debugMessage = json["error.msg"]?.toString() ?? self.UnexpectedErrorJson
				self.error = NSError.AppliveryError(debugMessage: debugMessage, code: self.code)
			}
		}
		catch let error as NSError {
			self.success = false
			self.code = error.code
			self.error = error
		}
	}
	
	
	// MARK - Private Helpers
	
	private func parseError(error: NSError?) {
		if error != nil {
			self.error = error
		}
		else {
			let userInfo: [String: String]
			
			switch self.code {
			case 401:
				userInfo = [GlobalConfig.AppliveryErrorKey: Localize("error_invalid_credentials")]
			default:
				userInfo = [GlobalConfig.AppliveryErrorKey: Localize("error_unexpected")]
			}
			
			self.error = NSError (
				domain: GlobalConfig.ErrorDomain,
				code: self.code,
				userInfo: userInfo
			)
		}
	}
	
	private func logResponse() {
		guard GlobalConfig.shared.logLevel == .Debug else { return }
		
		Log("******** RESPONSE ********")
		Log(" - URL:\t" + self.logURL())
		Log(" - CODE:\t" + "\(self.code)")
		self.logHeaders()
		Log(" - DATA:\n" + self.logData())
		Log("*************************\n")
	}
	
	private func logURL() -> String {
		guard let url = self.url?.absoluteString else {
			return "NO URL"
		}
		
		return url
	}
	
	private func logHeaders() {
		guard let headers = self.headers else { return }
		
		Log(" - HEADERS: {")
		
		for key in headers.keys {
			if let value = headers[key] {
				Log("\t\t\(key): \(value)")
			}
		}
		
		Log("}")
	}
	
	private func logData() -> String {
		guard let data = self.data else {
			return "NO DATA"
		}
		
		guard let dataJson = try? JSON.dataToJson(data) else {
			return String(data: data, encoding: NSUTF8StringEncoding)!
		}
		
		return "\(dataJson)"
	}
}
