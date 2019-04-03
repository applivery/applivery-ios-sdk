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
							loginDataManager: LoginDataManager(
								loginService: LoginService()
							),
							globalConfig: self.config,
							sessionPersister: SessionPersister(
								userDefaults: self.userDefaultsMock
							)
						),
						globalConfig: self.config
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
					var url: String?
					StubResponse.testRequest { url = $0 }
					self.appMock.spyDownloadClosure?()
					
					expect(url).toEventually(equal("/v1/build/LAST_BUILD_ID_TEST/downloadToken"))
				}
				context("and service returns a valid token") {
					beforeEach {
						self.appMock.stubOpenUrlResult = true
						StubResponse.mockResponse(for: "/v1/build/LAST_BUILD_ID_TEST/downloadToken", with: "request_token_ok.json")
						self.appMock.spyDownloadClosure?()
					}
					it("should open download url") {
						expect(self.appMock.spyOpenUrl.called).toEventually(beTrue())
						expect(self.appMock.spyOpenUrl.url).toEventually(equal("itms-services://?action=download-manifest&url=\(GlobalConfig.HostDownload)/v1/download/test_token/manifest.plist"))
					}
					it("should hide loading") {
						expect(self.appMock.spyHideLoadingCalled).toEventually(beTrue())
					}
				}
				context("but service returns ko") {
					beforeEach {
						self.appMock.stubOpenUrlResult = true
						StubResponse.mockResponse(for: "/v1/build/LAST_BUILD_ID_TEST/downloadToken", with: "ko.json")
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
			context("when ota needs auth") {
				var matchedDownloadURL = false
				var downloadHeaders: [String: String]?
				beforeEach {
					matchedDownloadURL = false
					downloadHeaders = nil
					StubResponse.testRequest(with: "ko.json", url: "/v1/build/LAST_BUILD_ID_TEST/downloadToken", matching: { _, _, headers in
						matchedDownloadURL = true
						downloadHeaders = headers
					})
					self.userDefaultsMock.stubDictionary = UserDefaultFakes.storedConfig(
						lastBuildID: "LAST_BUILD_ID_TEST",
						forceAuth: true
					)
					self.appMock.stubVersion = "1"
					self.updateCoordinator.otaUpdate()
					self.appMock.spyDownloadClosure?()
				}
				it("should show login alert") {
					expect(self.appMock.spyLoginView.called).toEventually(beTrue())
					expect(self.appMock.spyLoginView.message).toEventually(equal(literal(.loginMessage)))
				}
				context("when login is cancelled") {
					beforeEach {
						self.appMock.spyLoginCancelClosure?()
					}
					it("should hide loading") {
						expect(self.appMock.spyHideLoadingCalled).toEventually(beTrue())
					}
				}
				context("when login is KO") {
					var matchedLoginURL = false
					var loginBody: JSON?
					beforeEach {
						loginBody = nil
						let email = "test@applivery.com"
						let password = "TEST_PASSWORD"
						matchedLoginURL = false
						StubResponse.testRequest(url: "/v1/auth/login") { _, json, _ in
							matchedLoginURL = true
							loginBody = json
						}
						self.appMock.spyLoginClosure?(email, password)
					}
					it("should request user token") {
						expect(matchedLoginURL).toEventually(beTrue())
						expect(loginBody?["provider"]?.toString()).toEventually(equal("traditional"))
						expect(loginBody?["payload.user"]?.toString()).toEventually(equal("test@applivery.com"))
						expect(loginBody?["payload.password"]?.toString()).toEventually(equal("TEST_PASSWORD"))
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
						StubResponse.testRequest(with: "login_success.json", url: "/v1/auth/login") { _, json, _ in
							matchedLoginURL = true
							loginBody = json
						}
						self.appMock.spyLoginClosure?(email, password)
					}
					it("should request user token") {
						expect(matchedLoginURL).toEventually(beTrue())
						expect(loginBody?["provider"]?.toString()).toEventually(equal("traditional"))
						expect(loginBody?["payload.user"]?.toString()).toEventually(equal("test@applivery.com"))
						expect(loginBody?["payload.password"]?.toString()).toEventually(equal("TEST_PASSWORD"))
					}
					it("should request an authenticated download token") {
						expect(matchedDownloadURL).toEventually(beTrue())
						expect(downloadHeaders?["x-sdk-auth-token"]).toEventually(equal("test_user_token"))
					}
				}
			}
			context("when ota needs auth but was previously logged in") {
				var matchedDownloadURL = false
				var downloadHeaders: [String: String]?
				beforeEach {
					matchedDownloadURL = false
					downloadHeaders = nil
					StubResponse.testRequest(with: "ko.json", url: "/v1/build/LAST_BUILD_ID_TEST/downloadToken", matching: { _, _, headers in
						matchedDownloadURL = true
						downloadHeaders = headers
					})
					self.userDefaultsMock.stubDictionary = UserDefaultFakes.storedConfig(
						lastBuildID: "LAST_BUILD_ID_TEST",
						forceAuth: true,
						accessToken: AccessToken(token: "TEST_TOKEN")
					)
					
					self.appMock.stubVersion = "1"
					self.updateCoordinator.otaUpdate()
					self.appMock.spyDownloadClosure?()
				}
				it("should not show login alert") {
					expect(self.appMock.spyLoginView.called).toNotEventually(beTrue())
				}
				it("should request an authenticated download token") {
					expect(matchedDownloadURL).toEventually(beTrue())
					expect(downloadHeaders?["x-sdk-auth-token"]).toEventually(equal("TEST_TOKEN"))
				}
			}
		}
	}
	
}
