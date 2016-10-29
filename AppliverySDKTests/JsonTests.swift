//
//  JsonTests.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 4/11/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import XCTest
@testable import Applivery

class JsonTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }


	// MARK - Simple objects

	func test_simple_object_string() {
		let object = ["key": "value"]
		let json = JSON(from: object)

		XCTAssert(json["key"]?.toString() == "value")
    }

	func test_simple_object_bool() {
		let object = ["key": true]
		let json = JSON(from: object)

		XCTAssert(json["key"]?.toBool() == true)
	}

	func test_simple_object_int() {
		let object = ["key": 30]
		let json = JSON(from: object)

		XCTAssert(json["key"]?.toInt() == 30)
	}


	// MARK - Paths

	func test_path_string() {
		let object = ["key": ["key2": "value"]]
		let json = JSON(from: object)

		XCTAssert(json["key.key2"]?.toString() == "value")
		XCTAssert(json["key"]?["key2"]?.toString() == "value")
	}

	func test_path_bool() {
		let object = ["key": ["key2": true]]
		let json = JSON(from: object)

		XCTAssert(json["key.key2"]?.toBool() == true)
		XCTAssert(json["key"]?["key2"]?.toBool() == true)
	}

	func test_path_int() {
		let object = ["key": ["key2": 30]]
		let json = JSON(from: object)

		XCTAssert(json["key.key2"]?.toInt() == 30)
		XCTAssert(json["key"]?["key2"]?.toInt() == 30)
	}


	// MARK - Errors

	func test_not_an_object() {
		let object = "value"
		let json = JSON(from: object)

		XCTAssert(json.toString() == "value")
		XCTAssertNil(json["1"])
		XCTAssertNil(json["key"])
	}

	func test_wrong_path() {
		let object = ["key": ["key2": "value"]]
		let json = JSON(from: object)

		XCTAssertNil(json["key.key1"])
	}
}
