//
//  FeedbackSpecs.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez Agudo on 14/4/17.
//  Copyright © 2017 Applivery S.L. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs
@testable import Applivery

class FeedbackSpecs: QuickSpec {
	
	var feedbackPresenter: FeedbackPresenter!
	var feedbackViewMock: FeedbackViewMock!
	var imageManagerMock: ImageManagerMock!
	var config: GlobalConfig!
	var appMock: AppMock!
	var deviceMock: DeviceMock!
	var userDefaultsMock: UserDefaultsMock!
	
	override func spec() {
		describe("feedback") {
			beforeEach {
				self.config = GlobalConfig()
				GlobalConfig.shared = self.config
				self.userDefaultsMock = UserDefaultsMock()
				
				self.feedbackViewMock = FeedbackViewMock()
				self.imageManagerMock = ImageManagerMock()
				self.appMock = AppMock()
				self.deviceMock = DeviceMock()
				let feedbackCoordinator = FeedbackCoordinator()
				feedbackCoordinator.feedbackVC = self.feedbackViewMock
				
				self.feedbackPresenter = FeedbackPresenter(
					view: self.feedbackViewMock,
					feedbackInteractor: FeedbackInteractor(
						service: FeedbackService(
							app: self.appMock,
							device: self.deviceMock,
							config: self.config
						),
						configDataManager: ConfigDataManager(
							appInfo: self.appMock,
							configPersister: ConfigPersister(
								userDefaults: self.userDefaultsMock
							),
							configService: ConfigService()
						),
						loginInteractor: LoginInteractor(
							app: self.appMock,
							loginDataManager: LoginDataManager(
								loginService: LoginService()
							),
							globalConfig: self.config,
							sessionPersister: SessionPersister(
								userDefaults: self.userDefaultsMock
							)
						)
					),
					feedbackCoordinator: feedbackCoordinator,
					screenshotInteractor: ScreenshotInteractor(
						imageManager: self.imageManagerMock
					)
				)
			}
			afterEach {
				self.feedbackPresenter = nil
				self.feedbackViewMock = nil
				self.imageManagerMock = nil
				self.appMock = nil
				self.config = nil
				self.userDefaultsMock = nil
				
				OHHTTPStubs.removeAllStubs()
			}
			
			describe("view did load") {
				let imageFake = self.load(image: "test1")
				
				beforeEach {
					self.imageManagerMock.fakeScreenshot = Screenshot(image: imageFake)
					self.feedbackPresenter.viewDidLoad()
				}
				it("should show screenshot") {
					expect(self.feedbackViewMock.spyShowScreenshot.called).to(beTrue())
					expect(self.feedbackViewMock.spyShowScreenshot.image).to(be(imageFake))
				}
			}

			describe("user did tap close button") {
				beforeEach {
					self.feedbackPresenter.userDidTapCloseButton()
				}
				it("should dismiss feedback view") {
					expect(self.feedbackViewMock.spyDismissCalled).to(beTrue())
				}
			}
			
			describe("user did tap add feedback button") {
				let imageFake = self.load(image: "test1")
				let editedImageFake = self.load(image: "test2")
				
				beforeEach {
					self.feedbackViewMock.fakeEditedScreenshot = editedImageFake
					self.imageManagerMock.fakeScreenshot = Screenshot(image: imageFake)
					self.feedbackPresenter.userDidTapAddFeedbackButton()
				}
				it("should show formulary with edited image") {
					expect(self.feedbackViewMock.spyShowFeedbackFormulary.called).to(beTrue())
					expect(self.feedbackViewMock.spyShowFeedbackFormulary.preview).to(be(editedImageFake))
				}
			}
			
			describe("user did tap send feedback button") {
				let imageFake = self.load(image: "test1")
				let editedImageFake = self.load(image: "test2")
				beforeEach {
					self.feedbackViewMock.fakeEditedScreenshot = editedImageFake
					self.imageManagerMock.fakeScreenshot = Screenshot(image: imageFake)
					
					self.feedbackPresenter.viewDidLoad()
					self.feedbackPresenter.userDidTapAddFeedbackButton()
				}
				context("when message is empty") {
					beforeEach {
						self.feedbackViewMock.fakeMessage = nil
						self.feedbackPresenter.userDidTapSendFeedbackButton()
					}
					it("should ask for a message") {
						expect(self.feedbackViewMock.spyNeedMessageCalled).to(beTrue())
					}
				}
				context("when a message is provided") {
					var matchedFeedbackURL = false
					var json: JSON?
					var feedbackHeaders: [String: String]?
					
					beforeEach {
						StubResponse.testRequest(url: "/v1/feedback") { _, jsonSent, headersSent in
							matchedFeedbackURL = true
							json = jsonSent
							feedbackHeaders = headersSent
						}
						self.feedbackViewMock.fakeMessage = "Test message"
						self.config.appId = "APPID_TEST"
						self.appMock.stubBundleID = "BUNDLEID_TEST"
						self.appMock.stubVersion = "500"
						self.appMock.stubVersionName = "1.3"
						self.deviceMock.fakeModel = "iPhone 7"
						self.deviceMock.fakeType = "iPhone"
						self.deviceMock.fakeVendorId = "TEST_VENDOR_IDENTIFIER"
						self.deviceMock.fakeNetworkType = "3g"
						self.deviceMock.fakeResolution = "630x520"
						self.deviceMock.fakeOrientation = "portrait"
						self.deviceMock.fakeRamUsed = "80"
						self.deviceMock.fakeRamTotal = "60"
						self.deviceMock.fakeDiskFree = "40"
						self.deviceMock.fakeSystemVersion = "10.3"
					}
					afterEach {
						matchedFeedbackURL = false
						json = nil
					}
					context("but need auth") {
						beforeEach {
							self.userDefaultsMock.stubDictionary = UserDefaultFakes.storedConfig(
								forceAuth: true
							)
							self.feedbackPresenter.userDidTapSendFeedbackButton()
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
								expect(self.feedbackViewMock.spyShowMessage.called).to(beTrue())
								expect(self.feedbackViewMock.spyShowMessage.message).to(equal(literal(.loginMessage)))
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
							it("should send feedback") {
								expect(matchedFeedbackURL).toEventually(beTrue())
								expect(feedbackHeaders?["x-sdk-auth-token"]).toEventually(equal("test_user_token"))
							}
						}
					}
					// WHEN AUTH IS NOT NEEDED
					it("should start loading") {
						self.feedbackPresenter.userDidTapSendFeedbackButton()
						
						expect(self.feedbackViewMock.spyShowLoadingCalled).to(beTrue())
					}
					it("should send feedback with default feedback info and battery charging") {
						self.feedbackPresenter.userDidTapSendFeedbackButton()
						
						expect(matchedFeedbackURL).toEventually(beTrue())
						expect(json?["type"]?.toString()).toEventually(equal(FeedbackType.bug.rawValue))
						expect(json?["message"]?.toString()).toEventually(equal("Test message"))
						expect(json?["packageInfo.name"]?.toString()).toEventually(equal("BUNDLEID_TEST"))
						expect(json?["packageInfo.version"]?.toString()).toEventually(equal("500"))
						expect(json?["packageInfo.versionName"]?.toString()).toEventually(equal("1.3"))
						expect(json?["deviceInfo.device.model"]?.toString()).toEventually(equal("iPhone 7"))
						expect(json?["deviceInfo.device.vendor"]?.toString()).toEventually(equal("Apple"))
						expect(json?["deviceInfo.device.type"]?.toString()).toEventually(equal("iPhone"))
						expect(json?["deviceInfo.device.network"]?.toString()).toEventually(equal("3g"))
						expect(json?["deviceInfo.device.resolution"]?.toString()).toEventually(equal("630x520"))
						expect(json?["deviceInfo.device.orientation"]?.toString()).toEventually(equal("portrait"))
						expect(json?["deviceInfo.device.ramUsed"]?.toString()).toEventually(equal("80"))
						expect(json?["deviceInfo.device.ramTotal"]?.toString()).toEventually(equal("60"))
						expect(json?["deviceInfo.device.diskFree"]?.toString()).toEventually(equal("40"))
						expect(json?["deviceInfo.os.name"]?.toString()).toEventually(equal("ios"))
						expect(json?["deviceInfo.os.version"]?.toString()).toEventually(equal("10.3"))
						expect(json?["screenshot"]?.toString()).toEventually(equal("data:image/jpeg;base64,\(self.base64(image: editedImageFake) ?? "")"))
					}
					context("and battery is charging") {
						beforeEach {
							self.deviceMock.fakeBatteryState = true
							self.deviceMock.fakeBatteryLevel = 20
							self.feedbackPresenter.userDidTapSendFeedbackButton()
						}
						
						it("should send than battery is charging") {
							expect(matchedFeedbackURL).toEventually(beTrue())
							expect(json?["deviceInfo.device.batteryStatus"]?.toBool()).to(beTrue())
							expect(json?["deviceInfo.device.battery"]?.toInt()).to(equal(20))
						}
					}
					context("and battery is not charging") {
						beforeEach {
							self.deviceMock.fakeBatteryState = false
							self.deviceMock.fakeBatteryLevel = 30
							self.feedbackPresenter.userDidTapSendFeedbackButton()
						}
						it("should send that battery is not charging") {
							expect(matchedFeedbackURL).toEventually(beTrue())
							expect(json?["deviceInfo.device.batteryStatus"]?.toBool()).toNot(beTrue())
							expect(json?["deviceInfo.device.battery"]?.toInt()).to(equal(30))
						}
					}
					context("and user change to feedback") {
						beforeEach {
							self.feedbackPresenter.userDidSelectedFeedbackType(.feedback)
							self.feedbackPresenter.userDidTapSendFeedbackButton()
						}
						it("should send feedback type") {
							expect(matchedFeedbackURL).toEventually(beTrue())
							expect(json?["type"]?.toString()).toEventually(equal(FeedbackType.feedback.rawValue))
						}
					}
					context("and user don't attach screenshot") {
						beforeEach {
							self.feedbackPresenter.userDidChangedAttachScreenshot(attach: false)
							self.feedbackPresenter.userDidTapSendFeedbackButton()
						}
						it("should not send screenshot") {
							expect(matchedFeedbackURL).toEventually(beTrue())
							expect(json?["screenshot"]?.toString()).toEventually(equal("data:image/jpeg;base64,"))
						}
					}
					context("and service return with error") {
						beforeEach {
							StubResponse.mockResponse(for: "/v1/feedback", with: "ko.json")
							self.feedbackPresenter.userDidTapSendFeedbackButton()
						}
						it("should show error message") {
							expect(self.feedbackViewMock.spyShowMessage.called).toEventually(beTrue())
							expect(self.feedbackViewMock.spyShowMessage.message).toEventually(equal("Unexpected error"))
						}
					}
					context("and service return with success") {
						beforeEach {
							StubResponse.mockResponse(for: "/v1/feedback", with: "feedback_ok.json")
							self.feedbackPresenter.userDidTapSendFeedbackButton()
						}
						it("should stop loading") {
							expect(self.feedbackViewMock.spyStopLoadingCalled).toEventually(beTrue())
						}
						it("should close feedback") {
							expect(self.feedbackViewMock.spyDismissCalled).toEventually(beTrue())
						}
					}
				}
			}
			
			describe("user did tap attach screenshot") {
				beforeEach {
					self.feedbackPresenter.userDidChangedAttachScreenshot(attach: true)
				}
				it("should show preview") {
					expect(self.feedbackViewMock.spyShowScreenshotPreviewCalled).to(beTrue())
				}
			}
			
			describe("user dip tap don't attach screenshot") {
				beforeEach {
					self.feedbackPresenter.userDidChangedAttachScreenshot(attach: false)
				}
				it("should hide preview") {
					expect(self.feedbackViewMock.spyHideScreenshotPreviewCalled).to(beTrue())
				}
			}
			
			describe("user did tap preview") {
				let imageFake = self.load(image: "test1")
				let editedImageFake = self.load(image: "test2")
				
				beforeEach {
					self.feedbackViewMock.fakeEditedScreenshot = editedImageFake
					self.imageManagerMock.fakeScreenshot = Screenshot(image: imageFake)
					
					// Reproduce user steps
					self.feedbackPresenter.viewDidLoad()
					self.feedbackPresenter.userDidTapAddFeedbackButton()
					
					self.feedbackViewMock.spyShowScreenshot = (false, nil)	// Reset this mock to ensure userDidTapPreview call it
					self.feedbackPresenter.userDidTapPreview()
				}
				it("should show screenshot") {
					expect(self.feedbackViewMock.spyShowScreenshot.called).to(beTrue())
					expect(self.feedbackViewMock.spyShowScreenshot.image).to(beNil())
				}
			}
			
			describe("user did shake") {
				let imageFake = self.load(image: "test1")
				let editedImageFake = self.load(image: "test2")
				
				beforeEach {
					self.feedbackViewMock.fakeEditedScreenshot = editedImageFake
					self.imageManagerMock.fakeScreenshot = Screenshot(image: imageFake)
					
					self.feedbackPresenter.viewDidLoad()
				}
				context("when user is in the screenshot view") {
					beforeEach {
						self.feedbackPresenter.userDidShake()
					}
					it("should restore image") {
						expect(self.feedbackViewMock.spyRestoreScreenshot.called).to(beTrue())
						expect(self.feedbackViewMock.spyRestoreScreenshot.image).to(be(imageFake))
					}
				}
				context("when user is in add feedback view") {
					beforeEach {
						self.feedbackPresenter.userDidTapAddFeedbackButton()
						self.feedbackPresenter.userDidShake()
					}
					it("should do nothing") {
						expect(self.feedbackViewMock.spyRestoreScreenshot.called).toNot(beTrue())
					}
				}
				context("when user come back from feedback view") {
					beforeEach {
						self.feedbackPresenter.userDidTapAddFeedbackButton()
						self.feedbackPresenter.userDidTapPreview()
						self.feedbackPresenter.userDidShake()
					}
					it("should restore image") {
						expect(self.feedbackViewMock.spyRestoreScreenshot.called).to(beTrue())
						expect(self.feedbackViewMock.spyRestoreScreenshot.image).to(be(imageFake))
					}
				}
			}
		}
	}
	
	private func base64(image: UIImage) -> String? {
		let imageData = UIImageJPEGRepresentation(image, 0.9)
		let base64String = imageData?.base64EncodedString()
		
		return base64String
	}
	
	private func load(image: String) -> UIImage {
		let bundle = Bundle.init(for: FeedbackSpecs.self)
		let image = UIImage(named: image, in: bundle, compatibleWith: nil)
		return image!
	}
}
