//
//  Request.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 12/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation

class Request {
	
	var endpoint: String!
	var method = "GET"
	var headers: [String: String]!
	var urlParams: [String: String]?
	var bodyParams: [String: AnyObject]?
	
	private var url: NSURL!
	private var request: NSMutableURLRequest!
	
	
	func sendAsync(completionHandler: (Response) -> Void) {
		self.url = NSURL(string: GlobalConfig.Host + self.endpoint)
		let session = NSURLSession.sharedSession()
		self.request = NSMutableURLRequest(URL: url!)
		self.request.HTTPMethod = self.method
		
		if let bodyParams = self.bodyParams {
			request.HTTPBody = JSON(json: bodyParams).toData()
		}
		
		self.setHeaders(self.request)
		self.logRequest()

		let dataTask = session.dataTaskWithRequest(self.request) { data, response, error in
			let res = Response(data: data, response: response, error: error)

			runOnMainThread {
				completionHandler(res)
			}
		}
		
		dataTask.resume()
	}
	
	
	// MARK: Private Helpers
	
	private func setHeaders(request: NSMutableURLRequest) {
		let version = NSBundle.AppliveryBundle().infoDictionary!["CFBundleShortVersionString"] as! String
		
		request.setValue("application/json",		 forHTTPHeaderField: "Content-Type")
		request.setValue(GlobalConfig.shared.apiKey, forHTTPHeaderField: "Authorization")
		request.setValue(App().getLanguage(),		 forHTTPHeaderField: "Accept-Language")
		request.setValue("IOS_\(version)",			 forHTTPHeaderField: "x_sdk_version")
	}
	
	
	private func logRequest() {
		if GlobalConfig.shared.logLevel != .Debug {
			return
		}
		
		Log("******** REQUEST ********")
		Log(" - URL:\t" + self.url.absoluteString!)
		Log(" - METHOD:\t" + self.request.HTTPMethod)
		self.logBody()
		self.logHeaders()
		Log("*************************\n")
	}
	
	private func logBody() {
		guard
		let body = self.request.HTTPBody,
		let json = try? JSON.dataToJson(body)
		else { return }
		
		Log(" - BODY:\n\(json)")
	}
	
	private func logHeaders() {
		guard let headers = self.request.allHTTPHeaderFields else { return }
		
		Log(" - HEADERS: {")
		
		for key in headers.keys {
			if let value = headers[key] {
				Log("\t\t\(key): \(value)")
			}
		}
		
		Log("}")
	}
}
