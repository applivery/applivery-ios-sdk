//
//  DownloadServiceTests.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez Agudo on 27/10/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import Applivery

class DownloadServiceTests: XCTestCase {
	
	var downloadService: DownloadService!
    
    override func setUp() {
        super.setUp()
		
		self.downloadService = DownloadService()
    }
    
    override func tearDown() {
        self.downloadService = nil
		
        super.tearDown()
    }
    
    func test_not_nil() {
        XCTAssertNotNil(self.downloadService)
    }
	
	func test_resultSuccessWithToken_whenSuccess() {
		self.stubTokenOK()
		let completionCalled = self.expectation(description: "completion called")
		self.downloadService.fetchDownloadToken(with: "test_id") { result in
			completionCalled.fulfill()
			
			XCTAssert(self.downloadService.request?.endpoint == "/api/builds/test_id/token")
			XCTAssert(result == Result.success("test_token"), "result: \(result)")
		}
		
		self.waitForExpectations(timeout: 1, handler: nil)
	}
	
	func test_resultSuccessErrorUnexpected_whenSuccessNoToken() {
		self.stubSuccessNoToken()
		let completionCalled = self.expectation(description: "completion called")
		self.downloadService.fetchDownloadToken(with: "test_id") { result in
			completionCalled.fulfill()
			
			XCTAssert(self.downloadService.request?.endpoint == "/api/builds/test_id/token")
			XCTAssert(result == Result.error(NSError.unexpectedError(debugMessage: "Error trying to parse token", code: ErrorCodes.JsonParse)), "result: \(result)")
		}
		
		self.waitForExpectations(timeout: 1, handler: nil)
	}
	
	func test_resultError_whenError() {
		self.stubKO()
		let completionCalled = self.expectation(description: "completion called")
		self.downloadService.fetchDownloadToken(with: "test_id") { result in
			completionCalled.fulfill()
			
			XCTAssert(self.downloadService.request?.endpoint == "/api/builds/test_id/token")
			XCTAssert(result == Result.error(NSError.appliveryError(nil, debugMessage: "Error msg", code: 401)), "result: \(result)")
		}
		
		self.waitForExpectations(timeout: 1, handler: nil)
	}
	
	
	// MARK: - Private helpers
	
	private func stubTokenOK() {
		_ = stub(condition: isPath("/api/builds/test_id/token")) { _ in
			return StubResponse.stubResponse(with: "request_token_ok.json")
		}
	}
	
	private func stubSuccessNoToken() {
		_ = stub(condition: isPath("/api/builds/test_id/token")) { _ in
			return StubResponse.stubResponse(with: "request_token_ok_no_token.json")
		}
	}
	
	private func stubKO() {
		_ = stub(condition: isPath("/api/builds/test_id/token")) { _ in
			return StubResponse.stubResponse(with: "ko.json")
		}
	}
    
}
