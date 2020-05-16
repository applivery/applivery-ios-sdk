//
//  StartSpecs.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez Agudo on 1/4/17.
//  Copyright © 2017 Applivery S.L. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
@testable import Applivery

class StartSpecs: QuickSpec {
	
	let appToken = "API_KEY_TEST"
	
	var applivery: Applivery!
	var appMock: AppMock!
	var interactorOutputMock: StartInteractorOutputMock!
	var userDefaultsMock: UserDefaultsMock!
	var eventDetectorMock: EventDetectorMock!
	
	
	override func spec() {
		beforeSuite {
			Applivery.shared.logLevel = .debug
		}
		
		describe("applivery start") {
			beforeEach {
				let globalConfig = GlobalConfig()
				GlobalConfig.shared = globalConfig
				self.appMock = AppMock()
				self.userDefaultsMock = UserDefaultsMock()
				self.eventDetectorMock = EventDetectorMock()
				
				let configurator = ConfiguratorMock(
					appMock: self.appMock,
					userDefaultsMock: self.userDefaultsMock,
					globalConfig: globalConfig,
					eventDetectorMock: self.eventDetectorMock
				)
				self.applivery = configurator.applivery()
				self.applivery.startInteractor.output = self.applivery
				self.applivery.updateInteractor.output = self.applivery
			}
			afterEach {
				self.interactorOutputMock = nil
				self.appMock = nil
				self.userDefaultsMock = nil
				self.applivery = nil
				HTTPStubs.removeAllStubs()
			}
			
			context("when appToken is empty") {
				beforeEach {
					self.interactorOutputMock = StartInteractorOutputMock()
					self.applivery.startInteractor.output = self.interactorOutputMock
					self.applivery.start(token: "", appStoreRelease: false)
				}
				it("should return credentials error") {
					expect(self.interactorOutputMock.spyCredentialError.called).to(beTrue())
					expect(self.interactorOutputMock.spyCredentialError.message).toEventually(equal(kLocaleErrorEmptyCredentials))
				}
			}
			
			context("when server returns error 5004") {
				beforeEach {
					self.interactorOutputMock = StartInteractorOutputMock()
					self.applivery.startInteractor.output = self.interactorOutputMock
					StubResponse.mockResponse(for: "/v1/app", with: "error_5004.json")
					self.applivery.start(token: self.appToken, appStoreRelease: false)
				}
				it("should return subscription plan error") {
					expect(self.interactorOutputMock.spyCredentialError.called).toEventually(beTrue())
					expect(self.interactorOutputMock.spyCredentialError.message).toEventually(equal(kLocaleErrorSubscriptionPlan))
				}
			}
			
			context("when api ota version is greater than app version") {
				beforeEach {
					self.appMock.stubVersion = "34"
					StubResponse.mockResponse(for: "/v1/app", with: "config_success.json") // OTA UPDATE = 35
					self.applivery.start(token: self.appToken, appStoreRelease: false)
				}
				it("should show ota alert") {
					expect(self.appMock.spyOtaAlert.called).toEventually(beTrue())
				}
			}
			
			context("when api min version is greater than app version") {
				beforeEach {
					self.appMock.stubVersion = "9"
					StubResponse.mockResponse(for: "/v1/app", with: "config_success.json") // MIN VERSION = 10
					self.applivery.start(token: self.appToken, appStoreRelease: false)
				}
				it("should show force update") {
					expect(self.appMock.spyPresentModal.called)
						.toEventually(beTrue())
					expect((self.appMock.spyPresentModal.viewController as? UINavigationController)?.topViewController)
						.toEventually(beAKindOf(UpdateVC.self))
				}
			}
			
			context("when app version is up to date") {
				beforeEach {
					self.appMock.stubVersion = "50"
					StubResponse.mockResponse(for: "/v1/app", with: "config_success.json")
					self.applivery.start(token: self.appToken, appStoreRelease: false)
				}
				it("should do nothing but syncronize new data") {
					expect(self.userDefaultsMock.spySynchronizeCalled).toEventually(beTrue()) // This line needs to be invoked first
					expect(self.appMock.spyOtaAlert.called).toNotEventually(beTrue())
					expect(self.appMock.spyPresentModal.called).toNotEventually(beTrue())
				}
			}
			
			context("when api gets config") {
				beforeEach {
					self.appMock.stubVersion = "50"
					StubResponse.mockResponse(for: "/v1/app", with: "config_success.json")
					self.applivery.start(token: self.appToken, appStoreRelease: false)
				}
				it("stores a new config") {
					expect(self.userDefaultsMock.spySynchronizeCalled).toEventually(beTrue())
					expect(self.userDefaultsMock.spyDictionary).toEventually(equal(UserDefaultFakes.jsonConfigSuccess()))
				}
			}
			
			context("when api fails and there is a config with min version greater than app version") {
				beforeEach {
					self.appMock.stubVersion = "14"
					StubResponse.mockResponse(for: "/v1/app", with: "ko.json")
					self.userDefaultsMock.stubDictionary = UserDefaultFakes.storedConfig() // MIN VERSION = 15
					self.applivery.start(token: self.appToken, appStoreRelease: false)
				}
				it("should show force update") {
					expect(self.appMock.spyPresentModal.called)
						.toEventually(beTrue())
					expect((self.appMock.spyPresentModal.viewController as? UINavigationController)?.topViewController)
						.toEventually(beAKindOf(UpdateVC.self))
					expect(self.userDefaultsMock.spySynchronizeCalled)
						.toEventuallyNot(beTrue())
				}
			}
			
			context("when api fails and there is a config with last version greater than app version") {
				beforeEach {
					self.appMock.stubVersion = "49"
					StubResponse.mockResponse(for: "/v1/app", with: "ko.json")
					self.userDefaultsMock.stubDictionary = UserDefaultFakes.storedConfig() // LAST VERSION = 50
					self.applivery.start(token: self.appToken, appStoreRelease: false)
				}
				it("should show ota update") {
					expect(self.appMock.spyOtaAlert.called).toEventually(beTrue())
					expect(self.userDefaultsMock.spySynchronizeCalled).toEventuallyNot(beTrue())
				}
			}
			
			context("when api is success and there is a previous stored version") {
				beforeEach {
					// STORED_LAST(50) > API_LAST(35) > STORED_MIN(15) > APP_VERSION(13) > API_MIN(10)
					self.appMock.stubVersion = "13"
					StubResponse.mockResponse(for: "/v1/app", with: "config_success.json")
					self.userDefaultsMock.stubDictionary = UserDefaultFakes.storedConfig()
					self.applivery.start(token: self.appToken, appStoreRelease: false)
				}
				it("api shoud have priority") {
					// SO SHOW OTA ALERT BECAUSE API WINS
					expect(self.appMock.spyOtaAlert.called).toEventually(beTrue())
					expect(self.userDefaultsMock.spySynchronizeCalled).toEventually(beTrue())
				}
			}
			
			context("when api fails and there is no previous config stored") {
				beforeEach {
					self.appMock.stubVersion = "5"
					StubResponse.mockResponse(for: "/v1/app", with: "ko.json")
					self.userDefaultsMock.stubDictionary = nil
					self.applivery.start(token: self.appToken, appStoreRelease: false)
				}
				it("should do nothing") {
					Thread.sleep(forTimeInterval: 0.1) // Need to wait cause the 3 expects match by default.
					expect(self.userDefaultsMock.spySynchronizeCalled).toNotEventually(beTrue())
					expect(self.appMock.spyOtaAlert.called).toNotEventually(beTrue())
					expect(self.appMock.spyPresentModal.called).toNotEventually(beTrue())
				}
			}
			
			context("when appsStoreRelease enabled") {
				beforeEach {
					StubResponse.mockResponse(for: "/v1/app", with: "config_success.json")
					self.userDefaultsMock.stubDictionary = UserDefaultFakes.storedConfig()
					self.applivery.start(token: self.appToken, appStoreRelease: true)
				}
				it("should do nothing") {
					Thread.sleep(forTimeInterval: 0.1) // Need to wait cause the 3 expects match by default.
					expect(self.userDefaultsMock.spySynchronizeCalled).toNotEventually(beTrue())
					expect(self.appMock.spyOtaAlert.called).toNotEventually(beTrue())
					expect(self.appMock.spyPresentModal.called).toNotEventually(beTrue())
				}
				it("should listen events") {
					expect(self.eventDetectorMock.spyListenEventCalled).to(beTrue())
				}
			}
			context("developer call update method") {
				var onSuccessCalled = false
				var onError = (called: false, message: "")
				beforeEach {
					onSuccessCalled = false
					onError = (called: false, message: "")
					self.userDefaultsMock.stubDictionary = UserDefaultFakes.storedConfig(
						lastBuildID: "LAST_BUILD_ID_TEST"
					)
					self.appMock.stubOpenUrlResult = true
					
				}
				context("when request token is OK") {
					beforeEach {
						StubResponse.mockResponse(for: "/v1/build/LAST_BUILD_ID_TEST/downloadToken", with: "request_token_ok.json")
						self.applivery.update(
							onSuccess: {
								onSuccessCalled = true
						},
							onError: { message in
								onError.called = true
								onError.message = message
						})
					}
					it("should open download url") {
						expect(self.appMock.spyOpenUrl.called).toEventually(beTrue())
						expect(self.appMock.spyOpenUrl.url)
							.toEventually(equal("itms-services://?action=download-manifest&url=\(GlobalConfig.HostDownload)/v1/download/test_token/manifest.plist"))
					}
					it("should call success") {
						expect(onSuccessCalled).toEventually(beTrue())
					}
				}
				context("when request token fails") {
					beforeEach {
						StubResponse.mockResponse(for: "/v1/build/LAST_BUILD_ID_TEST/downloadToken", with: "error_5004.json")
						self.applivery.update(
							onSuccess: {
								onSuccessCalled = true
						},
							onError: { message in
								onError.called = true
								onError.message = message
						})
					}
					it("should call error") {
						expect(onError.called).toEventually(beTrue())
						expect(onError.message).toEventually(equal(kLocaleErrorSubscriptionPlan))
					}
				}
			}
			context("developer calls isUpToDate method") {
				context("when app version is older than newest applivery version") {
					beforeEach {
						self.appMock.stubVersion = "14"
						self.userDefaultsMock.stubDictionary = UserDefaultFakes.storedConfig() // LAST VERSION = 50
					}
					it("should return false") {
						expect(self.applivery.isUpToDate()).to(beFalse())
					}
				}
				context("when app version is newest than newest applivery version") {
					beforeEach {
						self.appMock.stubVersion = "55"
						self.userDefaultsMock.stubDictionary = UserDefaultFakes.storedConfig() // LAST VERSION = 50
					}
					it("should return true") {
						expect(self.applivery.isUpToDate()).to(beTrue())
					}
				}
				context("when app version is equal than newest applivery version") {
					beforeEach {
						self.appMock.stubVersion = "50"
						self.userDefaultsMock.stubDictionary = UserDefaultFakes.storedConfig() // LAST VERSION = 50
					}
					it("should return true") {
						expect(self.applivery.isUpToDate()).to(beTrue())
					}
				}
				
			}
			
			context("when disable feedback") {
				beforeEach {
					self.applivery.start(token: self.appToken, appStoreRelease: true)
					self.applivery.disableFeedback()
				}
				it("should not listen events") {
					expect(self.eventDetectorMock.spyEndListeningCalled).to(beTrue())
				}
			}
			
			context("when trigger feedback event") {
				beforeEach {
					self.applivery.start(token: self.appToken, appStoreRelease: true)
					self.eventDetectorMock.spyOnDetectionClosure()
				}
				it("should show FeedbackVC") {
					expect(self.appMock.spyPresentModal.called).toEventually(beTrue())
					expect(self.appMock.spyPresentModal.viewController).toEventually(beAnInstanceOf(FeedbackVC.self))
				}
				it("should show FeedbackVC only once") {
					let firstVC = self.appMock.spyPresentModal.viewController
					expect(self.appMock.spyPresentModal.called).to(beTrue())
					expect(self.appMock.spyPresentModal.viewController).to(beAnInstanceOf(FeedbackVC.self))
					
					self.eventDetectorMock.spyOnDetectionClosure()
					expect(self.appMock.spyPresentModal.viewController).to(be(firstVC))
				}
			}
		}
	}
}
