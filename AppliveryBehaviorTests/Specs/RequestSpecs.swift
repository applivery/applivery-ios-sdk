//
//  RequestSpecs.swift
//  AppliveryBehaviorTests
//
//  Created by Alejandro Jiménez Agudo on 26/08/2019.
//  Copyright © 2019 Applivery S.L. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
@testable import Applivery

class RequestSpecs: QuickSpec {
	
	var request: Request?
	var headersSent: [String: String]?
	var globalConfigMock: GlobalConfig?
	var appMock: AppMock?
	var deviceMock: DeviceMock?
	
	override func spec() {
		beforeSuite {
			Applivery.shared.logLevel = .debug
		}
		describe("Applivery Request") {
			beforeEach {
				self.request = Request(endpoint: "/test")
				self.appMock = AppMock()
				self.deviceMock = DeviceMock()
				
				self.globalConfigMock = GlobalConfig()
				self.globalConfigMock?.app = self.appMock!
				self.globalConfigMock?.device = self.deviceMock!
				GlobalConfig.shared = self.globalConfigMock ?? GlobalConfig()
			}
			afterEach {
				self.request = nil
				self.headersSent = nil
				self.appMock = nil
				self.deviceMock = nil
				self.globalConfigMock = nil
				GlobalConfig.shared = GlobalConfig()
				HTTPStubs.removeAllStubs()
			}
			context("when any request is performed") {
				beforeEach {
					self.appMock?.stubSDKVersion = "3.0"
					self.appMock?.stubVersionName = "1.8"
					self.appMock?.stubLanguage = "pt"
					self.appMock?.stubBundleID = "com.company.awesomeapp"
					self.appMock?.stubVersion = "3894"
					
					self.deviceMock?.fakeSystemVersion = "13.1.2"
					self.deviceMock?.fakeSystemName = "iOS"
					self.deviceMock?.fakeModel = "iPhone 11 Pro"
					self.deviceMock?.fakeType = "iPhone"
					
					StubResponse.testRequest(url: "/test") { _, _, headersSent in
						self.headersSent = headersSent
					}
					self.globalConfigMock?.appToken = "TEST_TOKEN"
					self.request?.sendAsync { _ in }
				}
				it("should send the basic headers") {
					expect(self.headersSent?["Content-Type"]).toEventually(equal("application/json"))
					expect(self.headersSent?["Accept-Language"]).toEventually(equal("pt"))
				}
				it("should send the Bearer header") {
					expect(self.headersSent?["Authorization"]).toEventually(equal("Bearer TEST_TOKEN"))
				}
				it("should send custom SDK headers") {
					expect(self.headersSent?["x-sdk-version"]).toEventually(equal("IOS_3.0"))
					expect(self.headersSent?["x-app-version"]).toEventually(equal("1.8"))
					expect(self.headersSent?["x-os-version"]).toEventually(equal("13.1.2"))
					expect(self.headersSent?["x-os-name"]).toEventually(equal("iOS"))
					expect(self.headersSent?["x-device-vendor"]).toEventually(equal("Apple"))
					expect(self.headersSent?["x-device-model"]).toEventually(equal("iPhone 11 Pro"))
					expect(self.headersSent?["x-device-type"]).toEventually(equal("iPhone"))
					expect(self.headersSent?["x-package-name"]).toEventually(equal("com.company.awesomeapp"))
					expect(self.headersSent?["x-package-version"]).toEventually(equal("3894"))
				}
			}
		}
	}
	
}
