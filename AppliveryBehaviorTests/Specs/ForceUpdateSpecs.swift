//
//  ForceUpdateSpecs.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez Agudo on 11/4/17.
//  Copyright © 2017 Applivery S.L. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
@testable import Applivery

class ForceUpdateSpecs: QuickSpec {
	
	var updatePresenter: UpdatePresenter!
	var config: GlobalConfig!
	var updateViewMock: UpdateViewMock!
	var appMock: AppMock!
	var userDefaultsMock: UserDefaultsMock!
	
	
	override func spec() {
		describe("force update") {
			beforeEach {
				self.config = GlobalConfig()
				GlobalConfig.shared = self.config
				
				self.updateViewMock = UpdateViewMock()
				self.appMock = AppMock()
				self.userDefaultsMock = UserDefaultsMock()
				
				self.updatePresenter = UpdatePresenter(
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
					view: self.updateViewMock
				)
				self.updatePresenter.updateInteractor.output = self.updatePresenter
				
			}
			afterEach {
				self.config = nil
				self.updatePresenter.updateInteractor.output = nil
				self.updateViewMock = nil
				self.appMock = nil
				self.userDefaultsMock = nil
				
				self.updatePresenter = nil
				
				OHHTTPStubs.removeAllStubs()
			}
			
			describe("view did load") {
				beforeEach {
					self.appMock.stubVersion = "1"
					self.config.textLiterals.forceUpdateMessage = "test force update message"
					self.updatePresenter.viewDidLoad()
				}
				it("should show update message") {
					expect(self.updateViewMock.spyShowUpdateMessage.called).to(beTrue())
					expect(self.updateViewMock.spyShowUpdateMessage.message).to(equal("test force update message"))
				}
			}
			
			describe("user did tap download") {
				beforeEach {
					self.appMock.stubVersion = "1"
					self.userDefaultsMock.stubDictionary = UserDefaultFakes.storedConfig(lastBuildID: "LAST_BUILD_ID_TEST")
				}
				it("should show loading") {
					self.updatePresenter.userDidTapDownload()
					expect(self.updateViewMock.spyShowLoadingCalled).to(beTrue())
				}
				it("should request a download token") {
					var url: String?
					StubResponse.testRequest { url = $0 }
					self.updatePresenter.userDidTapDownload()
					
					expect(url).toEventually(equal("/api/builds/LAST_BUILD_ID_TEST/token"))
				}
				context("and service returns a valid token") {
					beforeEach {
						self.appMock.stubOpenUrlResult = true
						StubResponse.mockResponse(for: "/api/builds/LAST_BUILD_ID_TEST/token", with: "request_token_ok.json")
						self.updatePresenter.userDidTapDownload()
					}
					it("should open download url") {
						expect(self.appMock.spyOpenUrl.called).toEventually(beTrue())
						expect(self.appMock.spyOpenUrl.url).toEventually(equal("itms-services://?action=download-manifest&url=https://dashboard.applivery.com/download/LAST_BUILD_ID_TEST/manifest/test_token"))
					}
					it("should hide loading") {
						expect(self.updateViewMock.spyStopLoadingCalled).toEventually(beTrue())
					}
				}
				context("but service returns ko") {
					beforeEach {
						self.appMock.stubOpenUrlResult = true
						StubResponse.mockResponse(for: "/api/builds/LAST_BUILD_ID_TEST/token", with: "ko.json")
						self.updatePresenter.userDidTapDownload()
					}
					it("should hide loading") {
						expect(self.updateViewMock.spyStopLoadingCalled).toEventually(beTrue())
					}
					it("should show error alert") {
						expect(self.updateViewMock.spyShowErrorMessage.called).toEventually(beTrue())
						expect(self.updateViewMock.spyShowErrorMessage.message).toEventually(equal("Unexpected error"))
					}
				}
			}
		}
	}
	
}
