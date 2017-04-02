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
	
	let appID = "APP_ID_TEST"
	let apiKey = "API_KEY_TEST"
	
	var applivery: Applivery!
	var appMock: AppMock!
	var interactorOutputMock: StartInteractorOutputMock!
	var userDefaultsMock: UserDefaultsMock!
	
	
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
				self.applivery = Applivery(
					startInteractor: StartInteractor(
						configDataManager: ConfigDataManager(
							appInfo: self.appMock,
							configPersister: ConfigPersister(
								userDefaults: self.userDefaultsMock
							),
							configService: ConfigService()
						),
						globalConfig: globalConfig,
						eventDetector: ScreenshotDetector()
					),
					globalConfig: globalConfig,
					updateCoordinator: UpdateCoordinator(
						updateInteractor: UpdateInteractor(),
						app: self.appMock
					),
					feedbackCoordinator: FeedbackCoordinator()
				)
				
				self.applivery.startInteractor.output = self.applivery
			}
			afterEach {
				self.interactorOutputMock = nil
				self.appMock = nil
				self.applivery = nil
				OHHTTPStubs.removeAllStubs()
			}
			
			context("when apiKey is empty") {
				beforeEach {
					self.interactorOutputMock = StartInteractorOutputMock()
					self.applivery.startInteractor.output = self.interactorOutputMock
					self.applivery.start(apiKey: "", appId: self.appID, appStoreRelease: false)
				}
				it("should return credentials error") {
					expect(self.interactorOutputMock.spyCredentialError.called).to(beTrue())
				}
			}
			
			context("when appId is empty") {
				beforeEach {
					self.interactorOutputMock = StartInteractorOutputMock()
					self.applivery.startInteractor.output = self.interactorOutputMock
					self.applivery.start(apiKey: self.apiKey, appId: "", appStoreRelease: false)
				}
				it("should return credentials error") {
					expect(self.interactorOutputMock.spyCredentialError.called).to(beTrue())
				}
			}
			
			context("when api ota version is greater than app version") {
				beforeEach {
					self.appMock.stubVersion = "34"
					StubResponse.mockResponse(for: "/api/apps/\(self.appID)", with: "config_success.json") // OTA UPDATE = 35
					self.applivery.start(apiKey: self.apiKey, appId: self.appID, appStoreRelease: false)
				}
				it("should show ota alert") {
					expect(self.appMock.spyOtaAlert.called).toEventually(beTrue())
				}
			}
			
			context("when api min version is greater than app version") {
				beforeEach {
					self.appMock.stubVersion = "9"
					StubResponse.mockResponse(for: "/api/apps/\(self.appID)", with: "config_success.json") // MIN VERSION = 10
					self.applivery.start(apiKey: self.apiKey, appId: self.appID, appStoreRelease: false)
				}
				it("should show force update") {
					expect(self.appMock.spyPresentModal.called).toEventually(beTrue())
					expect(self.appMock.spyPresentModal.viewController).toEventually(beAKindOf(UpdateVC.self))
				}
			}
			
			context("when app version is up to date") {
				beforeEach {
					self.appMock.stubVersion = "50"
					StubResponse.mockResponse(for: "/api/apps/\(self.appID)", with: "config_success.json") // OTA UPDATE = 35
					self.applivery.start(apiKey: self.apiKey, appId: self.appID, appStoreRelease: false)
				}
				it("should do nothing") {
					expect(self.userDefaultsMock.spySynchronizeCalled).toEventually(beTrue()) // This line needs to be invoked first
					expect(self.appMock.spyOtaAlert.called).toNotEventually(beTrue())
					expect(self.appMock.spyPresentModal.called).toNotEventually(beTrue())
				}
			}
		}
	}
	
}
