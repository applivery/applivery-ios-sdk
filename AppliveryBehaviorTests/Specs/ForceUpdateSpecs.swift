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
						output: nil,
						configData: ConfigDataManager(
							appInfo: self.appMock,
							configPersister: ConfigPersister(
								userDefaults: self.userDefaultsMock
							),
							configService: ConfigService()
						),
						downloadData: DownloadDataManager(),
						app: self.appMock,
						loginInteractor: LoginInteractor(
							app: self.appMock,
							loginService: LoginService(),
							globalConfig: self.config,
							sessionPersister: SessionPersister(
								userDefaults: self.userDefaultsMock
							)
						),
						globalConfig: self.config
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
			context("user did tap download") {
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
						expect(self.appMock.spyOpenUrl.url).toEventually(equal("itms-services://?action=download-manifest&url=\(GlobalConfig.Host)/download/LAST_BUILD_ID_TEST/manifest/test_token"))
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
			context("when download needs auth") {
				var matchedDownloadURL = false
//				var downloadHeaders: [String: String]?
				beforeEach {
					matchedDownloadURL = false
//					downloadHeaders = nil
					StubResponse.testRequest(with: "ko.json", url: "/api/builds/LAST_BUILD_ID_TEST/token", matching: { _, _, _ in
						matchedDownloadURL = true
//						downloadHeaders = headers
					})
					self.appMock.stubVersion = "1"
					self.userDefaultsMock.stubDictionary = UserDefaultFakes.storedConfig(
						lastBuildID: "LAST_BUILD_ID_TEST",
						authUpdate: true
					)
					self.updatePresenter.userDidTapDownload()
				}
				it("should show login alert") {
					expect(self.appMock.spyLoginView.called).toEventually(beTrue())
					expect(self.appMock.spyLoginView.message).toEventually(equal(literal(.loginMessage)))
				}
				context("when login is cancelled") {
					beforeEach {
						self.appMock.spyLoginCancelClosure?()
					}
					it("should stop loading") {
						expect(self.updateViewMock.spyStopLoadingCalled).toEventually(beTrue())
					}
				}
				context("when login is KO") {
					var matchedLoginURL = false
					var loginBody: JSON?
					beforeEach {
						let email = "test@applivery.com"
						let password = "TEST_PASSWORD"
						matchedLoginURL = false
						loginBody = nil
						StubResponse.testRequest(url: "/api/auth") { _, json, _ in
							matchedLoginURL = true
							loginBody = json
						}
						self.appMock.spyLoginClosure?(email, password)
					}
					it("should request user token") {
						expect(matchedLoginURL).toEventually(beTrue())
						expect(loginBody?["email"]?.toString()).toEventually(equal("test@applivery.com"))
						expect(loginBody?["password"]?.toString()).toEventually(equal("TEST_PASSWORD"))
					}
					it("should ask for login again") {
						expect(self.appMock.spyLoginView.called).toEventually(beTrue())
						expect(self.appMock.spyLoginView.message).toEventually(equal(literal(.loginInvalidCredentials)))
					}
				}
				context("when login is OK") {
					var matchedLoginURL = false
					var loginBody: JSON?
					beforeEach {
						loginBody = nil
						let email = "test@applivery.com"
						let password = "TEST_PASSWORD"
						matchedLoginURL = false
						StubResponse.testRequest(with: "login_success.json", url: "/api/auth") { _, json, _ in
							matchedLoginURL = true
							loginBody = json
						}
						self.appMock.spyLoginClosure?(email, password)
					}
					it("should request user token") {
						expect(matchedLoginURL).toEventually(beTrue())
						expect(loginBody?["email"]?.toString()).toEventually(equal("test@applivery.com"))
						expect(loginBody?["password"]?.toString()).toEventually(equal("TEST_PASSWORD"))
					}
					it("should request an authenticated download token") {
						expect(matchedDownloadURL).toEventually(beTrue())
//						expect(downloadHeaders?["Authorization"]).toEventually(equal("test_user_token"))
					}
				}
			}
			context("when ota needs auth but was previously logged in") {
				var matchedDownloadURL = false
//				var downloadHeaders: [String: String]?
				beforeEach {
					matchedDownloadURL = false
//					downloadHeaders = nil
					StubResponse.testRequest(with: "ko.json", url: "/api/builds/LAST_BUILD_ID_TEST/token", matching: { _, _, _ in
						matchedDownloadURL = true
//						downloadHeaders = headers
					})
					self.userDefaultsMock.stubDictionary = UserDefaultFakes.storedConfig(
						lastBuildID: "LAST_BUILD_ID_TEST",
						authUpdate: true,
						accessToken: AccessToken(token: "TEST_TOKEN", expirationDate: Date.today())
					)
					
					self.appMock.stubVersion = "1"
					self.updatePresenter.userDidTapDownload()
				}
				it("should not show login alert") {
					expect(self.appMock.spyLoginView.called).toNotEventually(beTrue())
				}
				it("should request an authenticated download token") {
					expect(matchedDownloadURL).toEventually(beTrue())
//					expect(downloadHeaders?["Authorization"]).toEventually(equal("TEST_TOKEN"))
				}
			}
		}
	}
	
}
