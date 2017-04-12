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
	
	class func testRequest(with json: String, matching: @escaping (String, JSON?) -> Void) {
		OHHTTPStubs.stubRequests(passingTest: { request -> Bool in
			let urlRequest = (request as NSURLRequest)
			let data = urlRequest.ohhttpStubs_HTTPBody()
			let json = data.flatMap { try? JSON.dataToJson($0) }
			
			matching(urlRequest.url?.path ?? "NO_URL", json)
			
			return true
		}) { _ in StubResponse.stubResponse(with: json) }
	}
	
	class func stubResponse(with json: String) -> OHHTTPStubsResponse {
		return OHHTTPStubsResponse(
			fileAtPath: OHPathForFile(json, StubResponse.self)!,
			statusCode: 200,
			headers: ["Content-Type": "application/json"]
		)
	}
	
}
