//
//  OTAUpdateSpecs.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez Agudo on 8/4/17.
//  Copyright © 2017 Applivery S.L. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
@testable import Applivery

class OTAUpdateSpecs: QuickSpec {
	
	var updateCoordinator: UpdateCoordinator!
	var config: GlobalConfig!
	var appMock: AppMock!
	var userDefaultsMock: UserDefaultsMock!
	
	
	override func spec() {
		describe("OTA Update") {
			beforeEach {
				self.config = GlobalConfig()
				GlobalConfig.shared = self.config
				
				self.appMock = AppMock()
				self.userDefaultsMock = UserDefaultsMock()
				
				self.updateCoordinator = UpdateCoordinator(
					updateInteractor: UpdateInteractor(
						configData: ConfigDataManager(
							appInfo: self.appMock,
							configPersister: ConfigPersister(
								userDefaults: self.userDefaultsMock
							),
							configService: ConfigService()
						),
						downloadData: DownloadDataManager(),
						app: self.appMock
					),
					app: self.appMock
				)
			}
			afterEach {
				self.config = nil
				self.appMock = nil
				self.userDefaultsMock = nil
				self.updateCoordinator = nil
				
				OHHTTPStubs.removeAllStubs()
			}
			
			context("when there is a new update") {
				beforeEach {
					self.config.textLiterals.otaUpdateMessage = "OTA UPDATE TESTS MESSAGE"
					self.appMock.stubVersion = "1"
					self.updateCoordinator.otaUpdate()
				}
				it("should wait for ready") {
					expect(self.appMock.spyWaitForReadyCalled).to(beTrue())
				}
				it("should prompt ota alert") {
					expect(self.appMock.spyOtaAlert.called).to(beTrue())
					expect(self.appMock.spyOtaAlert.message).to(equal("OTA UPDATE TESTS MESSAGE"))
				}
			}
			
			context("when user taps on download button") {
				beforeEach {
					self.userDefaultsMock.stubDictionary = UserDefaultFakes.storedConfig(lastBuildID: "LAST_BUILD_ID_TEST")
					self.appMock.stubVersion = "1"
					self.updateCoordinator.otaUpdate()
				}
				it("should show a loading") {
					self.appMock.spyDownloadClosure?()
					expect(self.appMock.spyShowLoadingCalled).to(beTrue())
					expect(self.appMock.spyHideLoadingCalled).toNot(beTrue())
				}
				it("should request a download token") {
					waitUntil { done in
						StubResponse.testRequest { url, _ in
							expect(url).to(equal("/api/builds/LAST_BUILD_ID_TEST/token"))
							done()
						}
						self.appMock.spyDownloadClosure?()
					}
				}
				
				context("and service returns a valid token") {
					beforeEach {
						self.appMock.stubOpenUrlResult = true
						StubResponse.mockResponse(for: "/api/builds/LAST_BUILD_ID_TEST/token", with: "request_token_ok.json")
						self.appMock.spyDownloadClosure?()
					}
					it("should open download url") {
						expect(self.appMock.spyOpenUrl.called).toEventually(beTrue())
						expect(self.appMock.spyOpenUrl.url).toEventually(equal("itms-services://?action=download-manifest&url=https://dashboard.applivery.com/download/LAST_BUILD_ID_TEST/manifest/test_token"))
					}
					it("should hide loading") {
						expect(self.appMock.spyHideLoadingCalled).toEventually(beTrue())
					}
				}
				context("but service returns ko") {
					beforeEach {
						self.appMock.stubOpenUrlResult = true
						StubResponse.mockResponse(for: "/api/builds/LAST_BUILD_ID_TEST/token", with: "ko.json")
						self.appMock.spyDownloadClosure?()
					}
					it("should hide loading") {
						expect(self.appMock.spyHideLoadingCalled).toEventually(beTrue())
					}
					it("should show error alert") {
						expect(self.appMock.spyAlertError.called).toEventually(beTrue())
						expect(self.appMock.spyAlertError.message).toEventually(equal("Unexpected error"))
					}
				}
			}
		}
	}
    
}
