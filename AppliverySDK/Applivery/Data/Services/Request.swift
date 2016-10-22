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
	var bodyParams: [String: Any]?

	fileprivate var url: URL!
	fileprivate var request: NSMutableURLRequest!


	func sendAsync(_ completionHandler: @escaping (Response) -> Void) {
		self.url = URL(string: GlobalConfig.Host + self.endpoint)
		let session = URLSession.shared
		self.request = NSMutableURLRequest(url: url!)
		self.request.httpMethod = self.method

		if let bodyParams = self.bodyParams {
			request.httpBody = JSON(json: bodyParams as AnyObject).toData() as Data?
		}

		self.setHeaders(self.request)
		self.logRequest()

		let task = session.dataTask(with: self.request as URLRequest, completionHandler: { data, response, error in
			let res = Response(data: data, response: response, error: error as NSError?)

			runOnMainThread {
				completionHandler(res)
			}
		})

		task.resume()
	}


	// MARK: Private Helpers

	fileprivate func setHeaders(_ request: NSMutableURLRequest) {
		let version = Bundle.AppliveryBundle().infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"

		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.setValue(GlobalConfig.shared.apiKey, forHTTPHeaderField: "Authorization")
		request.setValue(App().getLanguage(), forHTTPHeaderField: "Accept-Language")
		request.setValue("IOS_\(version)", forHTTPHeaderField: "x_sdk_version")
	}


	fileprivate func logRequest() {
		if GlobalConfig.shared.logLevel != .debug {
			return
		}

		Log("******** REQUEST ********")
		Log(" - URL:\t" + self.url.absoluteString)
		Log(" - METHOD:\t" + self.request.httpMethod)
		self.logBody()
		self.logHeaders()
		Log("*************************\n")
	}

	fileprivate func logBody() {
		guard
		let body = self.request.httpBody,
		let json = try? JSON.dataToJson(body)
		else { return }

		Log(" - BODY:\n\(json)")
	}

	fileprivate func logHeaders() {
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
