//
//  StubResponseHelper.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez Agudo on 27/10/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation
import OHHTTPStubs

class StubResponse {
	
	class func mockResponse(for urlPath: String, with jsonFile: String) {
		_ = stub(condition: isPath(urlPath), response: { _ in
			return StubResponse.stubResponse(with: jsonFile)
		})
	}
	
	class func stubResponse(with json: String) -> OHHTTPStubsResponse {
		return OHHTTPStubsResponse(
			fileAtPath: OHPathForFile(json, StubResponse.self)!,
			statusCode: 200,
			headers: ["Content-Type": "application/json"]
		)
	}
	
}
