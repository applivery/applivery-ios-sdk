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
        super.tearDown()
    }
	
	
	// MARK - Init Tests
	
	func test_init_returnsErrorUnexpected_whenEverythingIsNil() {
		let response = Response(data: nil, response: nil, error: nil)
		
		XCTAssert(response.success == false)
		XCTAssert(response.url?.absoluteString == nil)
		XCTAssert(response.code == -1)
		XCTAssert(response.error == NSError.UnexpectedError())
		XCTAssert(response.body == nil)
		XCTAssert(response.data == nil)
		XCTAssert(response.headers == nil)
	}

}
