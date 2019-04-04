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
		GlobalConfig.shared.logLevel = .none
		
		super.tearDown()
	}
	
	
	// MARK: - Init Tests
	
	func test_init_returnsErrorUnexpected_whenEverythingIsNil() {
		GlobalConfig.shared.logLevel = .debug
		let response = Response(data: nil, response: nil, error: nil)
		
		XCTAssert(response.success == false)
		XCTAssert(response.url?.absoluteString == nil)
		XCTAssert(response.code == -1)
		XCTAssert(response.error == NSError.unexpectedError())
		XCTAssert(response.body == nil)
		XCTAssert(response.data == nil)
		XCTAssert(response.headers == nil)
	}
	
	func test_init_returnsErrorUnexpectedWithLogs_whenEverythingIsNil() {
		
		let response = Response(data: nil, response: nil, error: nil)
		
		XCTAssert(response.success == false)
		XCTAssert(response.url?.absoluteString == nil)
		XCTAssert(response.code == -1)
		XCTAssert(response.error == NSError.unexpectedError())
		XCTAssert(response.body == nil)
		XCTAssert(response.data == nil)
		XCTAssert(response.headers == nil)
	}
	
	func test_init_returnsError_whenResponseIsNil() {
		let data = Data()
		let error = NSError.appliveryError("TEST MESSAGE")
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
		XCTAssert(response.url?.absoluteString == urlResponse.url?.absoluteString)
		XCTAssert(response.code == urlResponse.statusCode)
		XCTAssert(response.error == NSError.unexpectedError(code: urlResponse.statusCode))
		XCTAssert(response.body == nil)
		XCTAssert(response.data == nil)
		XCTAssert(response.headers == urlResponse.allHeaderFields)
	}
	
	func test_init_returnsError_whenResponseIsError() {
		let data = Data()
		let error = NSError.appliveryError("TEST MESSAGE")
		let urlResponse = self.responseError()
		
		let response = Response(data: data, response: urlResponse, error: error)
		
		XCTAssert(response.success == false)
		XCTAssert(response.url?.absoluteString == urlResponse.url?.absoluteString)
		XCTAssert(response.code == urlResponse.statusCode)
		XCTAssert(response.error == error)
		XCTAssert(response.body == nil)
		XCTAssert(response.data == data)
		XCTAssert(response.headers == urlResponse.allHeaderFields)
	}
	
	func test_init_returnsInvalidCredentials_whenResponseIsErrorInvalidCrendentials_andErrorIsNil() {
		let data = Data()
		let urlResponse = self.responseInvalidCredentials()
		
		let response = Response(data: data, response: urlResponse, error: nil)
		
		XCTAssert(response.success == false)
		XCTAssert(response.url?.absoluteString == urlResponse.url?.absoluteString)
		XCTAssert(response.code == urlResponse.statusCode)
		XCTAssert(response.error == NSError.appliveryError(literal(.errorInvalidCredentials), code: 401))
		XCTAssert(response.body == nil)
		XCTAssert(response.data == data)
		XCTAssert(response.headers == urlResponse.allHeaderFields)
	}
	
	func test_init_returnsErrorUnexpected_whenResponseSuccess_butDataIsNil() {
		let urlResponse = self.responseSuccess()
		
		let response = Response(data: nil, response: urlResponse, error: nil)
		
		XCTAssert(response.success == false)
		XCTAssert(response.url?.absoluteString == urlResponse.url?.absoluteString)
		XCTAssert(response.code == NSError.unexpectedError().code)
		XCTAssert(response.error == NSError.unexpectedError(debugMessage: "data is nil"))
		XCTAssert(response.body == nil)
		XCTAssert(response.data == nil)
		XCTAssert(response.headers == urlResponse.allHeaderFields)
	}
	
	func test_init_returnsErrorParsingJSON_whenResponseSuccess_butDataIsNotJSON() {
		let data = Data()
		let urlResponse = self.responseSuccess()
		
		let response = Response(data: data, response: urlResponse, error: nil)
		
		XCTAssert(response.success == false)
		XCTAssert(response.url?.absoluteString == urlResponse.url?.absoluteString)
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
		XCTAssert(response.url?.absoluteString == urlResponse.url?.absoluteString)
		XCTAssert(response.code == NSError.unexpectedError(debugMessage: ResponseTests.UnexpectedErrorJson).code)
		XCTAssert(response.error == NSError.unexpectedError(debugMessage: ResponseTests.UnexpectedErrorJson))
		XCTAssert(response.body == nil)
		XCTAssert(response.data == data)
		XCTAssert(response.headers == urlResponse.allHeaderFields)
	}
	
	func test_init_returnsFail_whenResponseSuccess_butGetsFailJson() {
		let data = self.dataJsonFail()
		let urlResponse = self.responseSuccess()
		
		let response = Response(data: data, response: urlResponse, error: nil)
		
		XCTAssert(response.success == false)
		XCTAssert(response.url?.absoluteString == urlResponse.url?.absoluteString)
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
		XCTAssert(response.url?.absoluteString == urlResponse.url?.absoluteString)
		XCTAssert(response.code == -1)
		XCTAssert(response.error == NSError.appliveryError(debugMessage: ResponseTests.UnexpectedErrorJson))
		XCTAssert(response.body == nil)
		XCTAssert(response.data == data)
		XCTAssert(response.headers == urlResponse.allHeaderFields)
	}
	
	func test_init_returnsSuccess_whenResponseSuccess_andDataIsSuccess() {
		let data = self.dataJsonSuccess()
		let urlResponse = self.responseSuccess()
		
		let response = Response(data: data, response: urlResponse, error: nil)
		
		XCTAssert(response.success == true)
		XCTAssert(response.url?.absoluteString == urlResponse.url?.absoluteString)
		XCTAssert(response.code == 200)
		XCTAssert(response.error == nil)
		XCTAssert(response.body?.toString() == "valid json response")
		XCTAssert(response.data == data)
		XCTAssert(response.headers == urlResponse.allHeaderFields)
	}
	
	func test_init_returnsSuccessWithLog_whenResponseSuccess_andDataIsSuccess() {
		let data = self.dataJsonSuccess()
		let urlResponse = self.responseSuccess()
		GlobalConfig.shared.logLevel = .debug
		
		let response = Response(data: data, response: urlResponse, error: nil)
		
		XCTAssert(response.success == true)
		XCTAssert(response.url?.absoluteString == urlResponse.url?.absoluteString)
		XCTAssert(response.code == 200)
		XCTAssert(response.error == nil)
		XCTAssert(response.body?.toString() == "valid json response")
		XCTAssert(response.data == data)
		XCTAssert(response.headers == urlResponse.allHeaderFields)
	}
	
	
	
	// MARK: - Helpers
	
	fileprivate static let UnexpectedErrorJson = "Unexpected error trying to parse Json"
	fileprivate static let InvalidCredentials = "Invalid credentials"
	
	func responseError() -> HTTPURLResponse {
		let response = HTTPURLResponse(
			url: URL(string: "http://url_test")!,
			statusCode: 404,
			httpVersion: nil,
			headerFields: [
				"header1": "test1",
				"header2": "test2"
			])
		
		return response!
	}
	
	func responseInvalidCredentials() -> HTTPURLResponse {
		let response = HTTPURLResponse(
			url: URL(string: "http://url_test")!,
			statusCode: 401,
			httpVersion: nil,
			headerFields: [
				"header1": "test1",
				"header2": "test2"
			])
		
		return response!
	}
	
	func responseSuccess() -> HTTPURLResponse {
		let response = HTTPURLResponse(
			url: URL(string: "http://url_test")!,
			statusCode: 200,
			httpVersion: nil,
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
	
	func dataJsonUnexpected() -> Data {
		let json = ["UnexpectedJson": true]
		let data = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
		
		return data
	}
	
	func dataJsonSuccess() -> Data {
		let json = [
			"status": true,
			"data": "valid json response"
			] as [String: Any]
		let data = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
		
		return data
	}
	
	func dataJsonFail() -> Data {
		let json = [
			"status": false,
			"code": 10001,
			"message": "TEST ERROR MESSAGE"
			] as [String: Any]
		let data = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
		
		return data
	}
	
	func dataJsonFailWithourErrorField() -> Data {
		let json = [
			"status": false,
			"someIrrelevantField": "this field has no purpose"
			] as [String: Any]
		let data = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
		
		return data
	}
	
	func errorJsonFail() -> NSError {
		return NSError.appliveryError(debugMessage: "TEST ERROR MESSAGE", code: 10001)
	}
}


func == (left: [String: String]?, right: [AnyHashable: Any]) -> Bool {
	return NSDictionary(dictionary: left!).isEqual(to: right)
}
