//
//  StubResponseHelper.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez Agudo on 27/10/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation
import OHHTTPStubs
@testable import Applivery

class StubResponse {
	
	class func mockResponse(for urlPath: String, with jsonFile: String) {
		_ = stub(condition: isPath(urlPath), response: { _ in
			return StubResponse.stubResponse(with: jsonFile)
		})
	}
	
	class func testRequest(with json: String = "ko.json", url: String? = nil, matching: @escaping (String, JSON?, [String: String]?) -> Void) {
		HTTPStubs.stubRequests(passingTest: { request -> Bool in
			let urlRequest = (request as NSURLRequest)
			let data = urlRequest.ohhttpStubs_HTTPBody()
			let json = data.flatMap { try? JSON.dataToJson($0) }
			let headers = urlRequest.allHTTPHeaderFields
			let requestURL = urlRequest.url?.path ?? "NO_URL"
			let expectedURL = url ?? requestURL
			if requestURL == expectedURL {
				matching(requestURL, json, headers)
				return true
			} else {
				return false
			}
		}, withStubResponse: { _ in StubResponse.stubResponse(with: json) })
	}
	
	class func testRequest(with json: String = "ko.json", url: String? = nil, matching: @escaping (String) -> Void) {
		self.testRequest(with: json, url: url) { url, _, _ in matching(url) }
	}
	
	class func stubResponse(with json: String) -> HTTPStubsResponse {
		return HTTPStubsResponse(
			fileAtPath: OHPathForFile(json, StubResponse.self)!,
			statusCode: 200,
			headers: ["Content-Type": "application/json"]
		)
	}
	
}
