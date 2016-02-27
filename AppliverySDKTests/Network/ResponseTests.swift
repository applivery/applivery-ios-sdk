//
//  ResponseTests.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 24/2/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import XCTest
@testable import Applivery


class ResponseTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
		GlobalConfig.shared.logLevel = .None
		
        super.tearDown()
    }
	
	
	// MARK - Init Tests
	
	func test_init_returnsErrorUnexpected_whenEverythingIsNil() {
		GlobalConfig.shared.logLevel = .Debug
		let response = Response(data: nil, response: nil, error: nil)
		
		XCTAssert(response.success == false)
		XCTAssert(response.url?.absoluteString == nil)
		XCTAssert(response.code == -1)
		XCTAssert(response.error == NSError.UnexpectedError())
		XCTAssert(response.body == nil)
		XCTAssert(response.data == nil)
		XCTAssert(response.headers == nil)
	}
	
	func test_init_returnsErrorUnexpectedWithLogs_whenEverythingIsNil() {
		
		let response = Response(data: nil, response: nil, error: nil)
		
		XCTAssert(response.success == false)
		XCTAssert(response.url?.absoluteString == nil)
		XCTAssert(response.code == -1)
		XCTAssert(response.error == NSError.UnexpectedError())
		XCTAssert(response.body == nil)
		XCTAssert(response.data == nil)
		XCTAssert(response.headers == nil)
	}
	
	func test_init_returnsError_whenResponseIsNil() {
		let data = NSData()
		let error = NSError.AppliveryError("TEST MESSAGE")
		let response = Response(data: data, response: nil, error: error)
		
		XCTAssert(response.success == false)
		XCTAssert(response.url?.absoluteString == nil)
		XCTAssert(response.code == error.code)
		XCTAssert(response.error == error)
		XCTAssert(response.body == nil)
		XCTAssert(response.data == data)
		XCTAssert(response.headers == nil)
	}
	
	func test_init_returnsErrorUnexpected_whenResponseIsError_dataIsNil_andErrorIsNil() {
		let urlResponse = self.responseError()
		
		let response = Response(data: nil, response: urlResponse, error: nil)
		
		XCTAssert(response.success == false)
		XCTAssert(response.url?.absoluteString == urlResponse.URL?.absoluteString)
		XCTAssert(response.code == urlResponse.statusCode)
		XCTAssert(response.error == NSError.UnexpectedError(code: urlResponse.statusCode))
		XCTAssert(response.body == nil)
		XCTAssert(response.data == nil)
		XCTAssert(response.headers == urlResponse.allHeaderFields)
	}
	
	func test_init_returnsError_whenResponseIsError() {
		let data = NSData()
		let error = NSError.AppliveryError("TEST MESSAGE")
		let urlResponse = self.responseError()
		
		let response = Response(data: data, response: urlResponse, error: error)
		
		XCTAssert(response.success == false)
		XCTAssert(response.url?.absoluteString == urlResponse.URL?.absoluteString)
		XCTAssert(response.code == urlResponse.statusCode)
		XCTAssert(response.error == error)
		XCTAssert(response.body == nil)
		XCTAssert(response.data == data)
		XCTAssert(response.headers == urlResponse.allHeaderFields)
	}
	
	func test_init_returnsInvalidCredentials_whenResponseIsErrorInvalidCrendentials_andErrorIsNil() {
		let data = NSData()
		let urlResponse = self.responseInvalidCredentials()
		
		let response = Response(data: data, response: urlResponse, error: nil)
		
		XCTAssert(response.success == false)
		XCTAssert(response.url?.absoluteString == urlResponse.URL?.absoluteString)
		XCTAssert(response.code == urlResponse.statusCode)
		XCTAssert(response.error == NSError.AppliveryError(Localize("error_invalid_credentials"), code: 401))
		XCTAssert(response.body == nil)
		XCTAssert(response.data == data)
		XCTAssert(response.headers == urlResponse.allHeaderFields)
	}
	
	func test_init_returnsErrorUnexpected_whenResponseSuccess_butDataIsNil() {
		let urlResponse = self.responseSuccess()
		
		let response = Response(data: nil, response: urlResponse, error: nil)
		
		XCTAssert(response.success == false)
		XCTAssert(response.url?.absoluteString == urlResponse.URL?.absoluteString)
		XCTAssert(response.code == NSError.UnexpectedError().code)
		XCTAssert(response.error == NSError.UnexpectedError("data is nil"))
		XCTAssert(response.body == nil)
		XCTAssert(response.data == nil)
		XCTAssert(response.headers == urlResponse.allHeaderFields)
	}
	
	func test_init_returnsErrorParsingJSON_whenResponseSuccess_butDataIsNotJSON() {
		let data = NSData()
		let urlResponse = self.responseSuccess()
		
		let response = Response(data: data, response: urlResponse, error: nil)
		
		XCTAssert(response.success == false)
		XCTAssert(response.url?.absoluteString == urlResponse.URL?.absoluteString)
		XCTAssert(response.code == self.errorCocoaNoValue().code)
		XCTAssert(response.error == self.errorCocoaNoValue())
		XCTAssert(response.body == nil)
		XCTAssert(response.data == data)
		XCTAssert(response.headers == urlResponse.allHeaderFields)
	}
	
	func test_init_returnsErrorParsingJSON_whenResponseSuccess_butDataIsAnUnexpectedJSON() {
		let data = self.dataJsonUnexpected()
		let urlResponse = self.responseSuccess()
		
		let response = Response(data: data, response: urlResponse, error: nil)
		
		XCTAssert(response.success == false)
		XCTAssert(response.url?.absoluteString == urlResponse.URL?.absoluteString)
		XCTAssert(response.code == NSError.UnexpectedError(self.UnexpectedErrorJson).code)
		XCTAssert(response.error == NSError.UnexpectedError(self.UnexpectedErrorJson))
		XCTAssert(response.body == nil)
		XCTAssert(response.data == data)
		XCTAssert(response.headers == urlResponse.allHeaderFields)
	}
	
	func test_init_returnsFail_whenResponseSuccess_butGetsFailJson() {
		let data = self.dataJsonFail()
		let urlResponse = self.responseSuccess()
		
		let response = Response(data: data, response: urlResponse, error: nil)
		
		XCTAssert(response.success == false)
		XCTAssert(response.url?.absoluteString == urlResponse.URL?.absoluteString)
		XCTAssert(response.code == self.errorJsonFail().code)
		XCTAssert(response.error == self.errorJsonFail())
		XCTAssert(response.body == nil)
		XCTAssert(response.data == data)
		XCTAssert(response.headers == urlResponse.allHeaderFields)
	}
	
	func test_init_returnsFailUnexpected_whenResponseSuccess_butGetsFailJsonWithoutErrorField() {
		let data = self.dataJsonFailWithourErrorField()
		let urlResponse = self.responseSuccess()
		
		let response = Response(data: data, response: urlResponse, error: nil)
		
		XCTAssert(response.success == false)
		XCTAssert(response.url?.absoluteString == urlResponse.URL?.absoluteString)
		XCTAssert(response.code == -1)
		XCTAssert(response.error == NSError.AppliveryError(debugMessage: self.UnexpectedErrorJson))
		XCTAssert(response.body == nil)
		XCTAssert(response.data == data)
		XCTAssert(response.headers == urlResponse.allHeaderFields)
	}
	
	func test_init_returnsSuccess_whenResponseSuccess_andDataIsSuccess() {
		let data = self.dataJsonSuccess()
		let urlResponse = self.responseSuccess()
		
		let response = Response(data: data, response: urlResponse, error: nil)
		
		XCTAssert(response.success == true)
		XCTAssert(response.url?.absoluteString == urlResponse.URL?.absoluteString)
		XCTAssert(response.code == 200)
		XCTAssert(response.error == nil)
		XCTAssert(response.body?.toString() == "valid json response")
		XCTAssert(response.data == data)
		XCTAssert(response.headers == urlResponse.allHeaderFields)
	}
	
	func test_init_returnsSuccessWithLog_whenResponseSuccess_andDataIsSuccess() {
		let data = self.dataJsonSuccess()
		let urlResponse = self.responseSuccess()
		GlobalConfig.shared.logLevel = .Debug
		
		let response = Response(data: data, response: urlResponse, error: nil)
		
		XCTAssert(response.success == true)
		XCTAssert(response.url?.absoluteString == urlResponse.URL?.absoluteString)
		XCTAssert(response.code == 200)
		XCTAssert(response.error == nil)
		XCTAssert(response.body?.toString() == "valid json response")
		XCTAssert(response.data == data)
		XCTAssert(response.headers == urlResponse.allHeaderFields)
	}



	// MARK - Helpers
	
	private let UnexpectedErrorJson = "Unexpected error trying to parse Json"
	private let InvalidCredentials = "Invalid credentials"
	
	func responseError() -> NSHTTPURLResponse {
		let response = NSHTTPURLResponse(
			URL: NSURL(string: "http://url_test")!,
			statusCode: 404,
			HTTPVersion: nil,
			headerFields: [
				"header1": "test1",
				"header2": "test2"
			])
		
		return response!
	}
	
	func responseInvalidCredentials() -> NSHTTPURLResponse {
		let response = NSHTTPURLResponse(
			URL: NSURL(string: "http://url_test")!,
			statusCode: 401,
			HTTPVersion: nil,
			headerFields: [
				"header1": "test1",
				"header2": "test2"
			])
		
		return response!
	}
	
	func responseSuccess() -> NSHTTPURLResponse {
		let response = NSHTTPURLResponse(
			URL: NSURL(string: "http://url_test")!,
			statusCode: 200,
			HTTPVersion: nil,
			headerFields: [
				"header1": "test1",
				"header2": "test2"
			])
		
		return response!
	}
	
	func errorCocoaNoValue() -> NSError {
		return NSError(
			domain: NSCocoaErrorDomain,
			code: 3840,
			userInfo: ["NSDebugDescription": "No value."]
		)
	}
	
	func dataJsonUnexpected() -> NSData {
		let json = ["UnexpectedJson": true]
		let data = try! NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
		
		return data
	}
	
	func dataJsonSuccess() -> NSData {
		let json = [
			"status": true,
			"response": "valid json response"
		]
		let data = try! NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
		
		return data
	}
	
	func dataJsonFail() -> NSData {
		let json = [
			"status": false,
			"error": [
				"code": 10001,
				"msg": "TEST ERROR MESSAGE"
			]
		]
		let data = try! NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
		
		return data
	}
	
	func dataJsonFailWithourErrorField() -> NSData {
		let json = [
			"status": false,
			"someIrrelevantField": "this field has no purpose"
		]
		let data = try! NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
		
		return data
	}
	
	func errorJsonFail() -> NSError {
		return NSError.AppliveryError(debugMessage: "TEST ERROR MESSAGE", code: 10001)
	}
}


func ==(lhs: [String: String]?, rhs: [NSObject: AnyObject]) -> Bool {
	return NSDictionary(dictionary: lhs!).isEqualToDictionary(rhs)
}
