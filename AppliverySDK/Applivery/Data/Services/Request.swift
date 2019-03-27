//
//  Request.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 12/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation


class Request {

	var endpoint: String
	var method: String
	var urlParams: [String: String]
	var bodyParams: [String: Any?]

	private var headers: [String: String]?
	private var request: URLRequest?
	
	init(endpoint: String, method: String = "GET", urlParams: [String: String] = [:], bodyParams: [String: Any] = [:]) {
		self.method = method
		self.endpoint = endpoint
		self.urlParams = urlParams
		self.bodyParams = bodyParams
	}

	func sendAsync(_ completionHandler: @escaping (Response) -> Void) {
		self.buildRequest()
		guard let request = self.request else { return logWarn("Couldn't build the request") }
		self.logRequest()
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			let res = Response(data: data, response: response, error: error as NSError?)

			DispatchQueue.main.async {
				completionHandler(res)
			}
		}

		task.resume()
	}


	// MARK: Private Helpers
	
	private func buildRequest() {
		guard let url = self.buildURL() else { return logWarn("Could not build the URL") }
		self.request = URLRequest(url: url)
		self.request?.httpMethod = self.method
		if self.method != "GET" {
			let body = self.bodyParams.filter { $0.value != nil }.mapValues { $0 }
			self.request?.httpBody = JSON(from: body).toData()
		}
		self.setHeaders()
	}
	
	private func buildURL() -> URL? {
		guard var url = URLComponents(string: GlobalConfig.Host) else { return nil }
		
		url.path += self.endpoint
		
		if !self.urlParams.isEmpty {
			url.queryItems = self.urlParams.map(URLQueryItem.init(name:value:))
		}
		
		return url.url
	}

	private func setHeaders() {
		let version = GlobalConfig.SDKVersion
		let appToken = "Bearer \(GlobalConfig.shared.appToken)"
		
		self.request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
		self.request?.setValue(appToken, forHTTPHeaderField: "Authorization")
		self.request?.setValue(App().getLanguage(), forHTTPHeaderField: "Accept-Language")
		self.request?.setValue("IOS_\(version)", forHTTPHeaderField: "x-sdk-version")
		
		if let authToken = GlobalConfig.shared.accessToken?.token {
			self.request?.setValue(authToken, forHTTPHeaderField: "x-sdk-auth-token")
		}
	}


	private func logRequest() {
		if GlobalConfig.shared.logLevel != .debug {
			return
		}
		
		let url = self.request?.url?.absoluteString ?? "INVALID URL"

		log("******** REQUEST ********")
		log(" - URL:\t" + url)
		log(" - METHOD:\t" + (self.request?.httpMethod ?? "INVALID REQUEST"))
		self.logHeaders()
		self.logBody()
		log("*************************\n")
	}

	private func logBody() {
		guard
		let body = self.request?.httpBody,
		let json = try? JSON.dataToJson(body)
		else { return }

		log(" - BODY:\n\(json)")
	}

	private func logHeaders() {
		guard let headers = self.request?.allHTTPHeaderFields else { return }

		log(" - HEADERS: {")

		for key in headers.keys {
			if let value = headers[key] {
				log("\t\t\(key): \(value)")
			}
		}

		log("}")
	}
	
}
