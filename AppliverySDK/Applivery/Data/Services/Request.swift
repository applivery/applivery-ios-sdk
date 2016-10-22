//
//  Request.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 12/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation


protocol RequestProtocol {
	var endpoint: String { get set }
	var method: String { get set }
	var urlParams: [String: String] { get set }
	var bodyParams: [String: Any] { get set }
	
	func sendAsync(_ completionHandler: @escaping (Response) -> Void)
}


class Request {

	var endpoint: String
	var method: String
	var urlParams: [String: String]
	var bodyParams: [String: Any]

	private var headers: [String: String]?
	private var request: URLRequest?
	
	init(endpoint: String, method: String = "GET", urlParams: [String: String] = [:], bodyParams: [String: Any] = [:]) {
		self.method = method
		self.endpoint = endpoint
		self.urlParams = urlParams
		self.bodyParams = bodyParams
	}

	func sendAsync(_ completionHandler: @escaping (Response) -> Void) {
		guard let request = self.request else { return LogWarn("Couldn't build the request") }
		self.logRequest()
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			let res = Response(data: data, response: response, error: error as? NSError)

			DispatchQueue.main.async {
				completionHandler(res)
			}
		}

		task.resume()
	}


	// MARK: Private Helpers
	private func buildRequest() {
		guard let url = self.buildURL() else { return LogWarn("Could not build the URL") }
		self.request = URLRequest(url: url)
		self.request?.httpMethod = self.method
		self.request?.httpBody = JSON(from: self.bodyParams).toData()
		self.setHeaders()
	}
	
	private func buildURL() -> URL? {
		guard var url = URLComponents(string: GlobalConfig.Host) else { return nil }
		
		url.path = url.path + self.endpoint
		url.queryItems = self.urlParams.map(URLQueryItem.init(name:value:))
		
		return url.url
	}

	private func setHeaders() {
		let version = Bundle.AppliveryBundle().infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"

		self.request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
		self.request?.setValue(GlobalConfig.shared.apiKey, forHTTPHeaderField: "Authorization")
		self.request?.setValue(App().getLanguage(), forHTTPHeaderField: "Accept-Language")
		self.request?.setValue("IOS_\(version)", forHTTPHeaderField: "x_sdk_version")
	}


	private func logRequest() {
		if GlobalConfig.shared.logLevel != .debug {
			return
		}
		
		let url = self.request?.url?.absoluteString ?? "INVALID URL"

		Log("******** REQUEST ********")
		Log(" - URL:\t" + url)
		Log(" - METHOD:\t" + (self.request?.httpMethod ?? "INVALID REQUEST"))
		self.logBody()
		self.logHeaders()
		Log("*************************\n")
	}

	private func logBody() {
		guard
		let body = self.request?.httpBody,
		let json = try? JSON.dataToJson(body)
		else { return }

		Log(" - BODY:\n\(json)")
	}

	private func logHeaders() {
		guard let headers = self.request?.allHTTPHeaderFields else { return }

		Log(" - HEADERS: {")

		for key in headers.keys {
			if let value = headers[key] {
				Log("\t\t\(key): \(value)")
			}
		}

		Log("}")
	}
}
