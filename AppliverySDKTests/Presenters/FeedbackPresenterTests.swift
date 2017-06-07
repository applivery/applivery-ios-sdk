//
//  FeedbackPresenterTests.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 21/4/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import XCTest
@testable import Applivery


class FeedbackPresenterTests: XCTestCase {

	var feedbackPresenter: FeedbackPresenter!
	var screenshotInteractorMock: ScreenshotInteractorMock!
	var feedbackViewMock: FeedbackViewMock!
	var feedbackCoordinatorMock: FeedbackCoordinatorMock!
	var feedbackInteractorMock: FeedbackInteractorMock!


    override func setUp() {
        super.setUp()

		self.feedbackViewMock = FeedbackViewMock()
		self.feedbackInteractorMock = FeedbackInteractorMock()
		self.feedbackCoordinatorMock = FeedbackCoordinatorMock()
		self.screenshotInteractorMock = ScreenshotInteractorMock()
		
		self.feedbackPresenter = FeedbackPresenter(
			view: self.feedbackViewMock,
			feedbackInteractor: self.feedbackInteractorMock,
			feedbackCoordinator: self.feedbackCoordinatorMock,
			screenshotInteractor: self.screenshotInteractorMock
		)
    }

    override func tearDown() {
		self.feedbackPresenter = nil
		self.screenshotInteractorMock = nil
		self.feedbackViewMock = nil
		self.feedbackCoordinatorMock = nil
		self.feedbackInteractorMock = nil

        super.tearDown()
    }


    func test_not_nil() {
        XCTAssertNotNil(self.feedbackPresenter)
    }

	func test_viewDidLoad() {
		let image = UIImage()
		self.screenshotInteractorMock.fakeScreenshot = Screenshot(image: image)

		self.feedbackPresenter.viewDidLoad()

		XCTAssert(self.feedbackViewMock.spyShowScreenshot.called == true)
		XCTAssert(self.feedbackViewMock.spyShowScreenshot.image == image)
	}

	func test_userDidTapCloseButton() {
		self.feedbackPresenter.userDidTapCloseButton()

		XCTAssert(self.feedbackCoordinatorMock.outCloseFeedbackCalled == true)
	}

	func test_userDidTapAddFeedbackButton() {
		let editedScreenshot = UIImage()
		self.feedbackViewMock.fakeEditedScreenshot = editedScreenshot
		
		self.feedbackPresenter.userDidTapAddFeedbackButton()

		XCTAssert(self.feedbackViewMock.spyShowFeedbackFormulary.called == true)
		XCTAssert(self.feedbackViewMock.spyShowFeedbackFormulary.preview == editedScreenshot)
	}


	// MARK: - Tests change attach screenshot

	func test_userDidChangeAttachScreenshot_callsShowScreenshotPreview_whenOnIsTrue() {
		self.feedbackPresenter.userDidChangedAttachScreenshot(attach: true)

		XCTAssert(self.feedbackViewMock.spyShowScreenshotPreviewCalled == true)
		XCTAssert(self.feedbackViewMock.spyHideScreenshotPreviewCalled == false)
	}

	func test_userDidChangedAttachScreenshot_callsHideScreenshotPreview_whenOnIsFalse() {
		self.feedbackPresenter.userDidChangedAttachScreenshot(attach: false)

		XCTAssert(self.feedbackViewMock.spyShowScreenshotPreviewCalled == false)
		XCTAssert(self.feedbackViewMock.spyHideScreenshotPreviewCalled == true)
	}


	// MARK: - Tests send feedback

	func test_userDidTapSendFeedbackButton_callsNeedMessage_whenViewHasNoMessage() {
		self.feedbackPresenter.userDidTapSendFeedbackButton()

		XCTAssert(self.feedbackViewMock.spyNeedMessageCalled == true)
	}

	func test_userDidTapSendFeedbackButton_closeFeedback_whenSuccess() {
		// ARRANGE
		self.feedbackViewMock.fakeMessage = "test message"
		self.feedbackInteractorMock.inResult = .success


		// ACT
		self.feedbackPresenter.userDidTapSendFeedbackButton()

		// ASSERT
		XCTAssert(self.feedbackViewMock.spyNeedMessageCalled == false)
		XCTAssert(self.feedbackViewMock.spyShowLoadingCalled == true)
		XCTAssert(self.feedbackViewMock.spyStopLoadingCalled == true)
		XCTAssert(self.feedbackCoordinatorMock.outCloseFeedbackCalled == true)
		XCTAssert(self.feedbackInteractorMock.outSendFeedback.called == true)
		XCTAssert(self.feedbackInteractorMock.outSendFeedback.feedback?.message == "test message")
		XCTAssert(self.feedbackInteractorMock.outSendFeedback.feedback?.feedbackType == .bug)
		XCTAssert(self.feedbackInteractorMock.outSendFeedback.feedback?.screenshot == nil)
		XCTAssert(self.feedbackViewMock.spyShowMessage.called == false)
	}

	func test_userDidTapSendFeedbackButton_showErrorMessage_whenError() {
		// ARRANGE
		self.feedbackViewMock.fakeMessage = "test message"
		self.feedbackInteractorMock.inResult = .error("test error")


		// ACT
		self.feedbackPresenter.userDidTapSendFeedbackButton()

		// ASSERT
		XCTAssert(self.feedbackViewMock.spyNeedMessageCalled == false)
		XCTAssert(self.feedbackViewMock.spyShowLoadingCalled == true)
		XCTAssert(self.feedbackViewMock.spyStopLoadingCalled == false)
		XCTAssert(self.feedbackCoordinatorMock.outCloseFeedbackCalled == false)
		XCTAssert(self.feedbackInteractorMock.outSendFeedback.called == true)
		XCTAssert(self.feedbackInteractorMock.outSendFeedback.feedback?.message == "test message")
		XCTAssert(self.feedbackInteractorMock.outSendFeedback.feedback?.feedbackType == .bug)
		XCTAssert(self.feedbackInteractorMock.outSendFeedback.feedback?.screenshot == nil)
		XCTAssert(self.feedbackViewMock.spyShowMessage.called == true)
		XCTAssert(self.feedbackViewMock.spyShowMessage.message == "test error")
	}

	func test_userDidTapSendFeedbackButton_feedbackSentIsBugType_whenSelectedBugType() {
		// ARRANGE
		self.feedbackViewMock.fakeMessage = "test message"
		self.feedbackInteractorMock.inResult = .success

		self.feedbackPresenter.userDidSelectedFeedbackType(.bug)


		// ACT
		self.feedbackPresenter.userDidTapSendFeedbackButton()

		// ASSERT
		XCTAssert(self.feedbackViewMock.spyNeedMessageCalled == false)
		XCTAssert(self.feedbackViewMock.spyShowLoadingCalled == true)
		XCTAssert(self.feedbackViewMock.spyStopLoadingCalled == true)
		XCTAssert(self.feedbackCoordinatorMock.outCloseFeedbackCalled == true)
		XCTAssert(self.feedbackInteractorMock.outSendFeedback.called == true)
		XCTAssert(self.feedbackInteractorMock.outSendFeedback.feedback?.message == "test message")
		XCTAssert(self.feedbackInteractorMock.outSendFeedback.feedback?.feedbackType == .bug)
		XCTAssert(self.feedbackInteractorMock.outSendFeedback.feedback?.screenshot == nil)
		XCTAssert(self.feedbackViewMock.spyShowMessage.called == false)
	}

	func test_userDidTapSendFeedbackButton_feedbackSentIsFeedbackType_whenSelectedFeedbackType() {
		// ARRANGE
		self.feedbackViewMock.fakeMessage = "test message"
		self.feedbackInteractorMock.inResult = .success

		self.feedbackPresenter.userDidSelectedFeedbackType(.feedback)


		// ACT
		self.feedbackPresenter.userDidTapSendFeedbackButton()

		// ASSERT
		XCTAssert(self.feedbackViewMock.spyNeedMessageCalled == false)
		XCTAssert(self.feedbackViewMock.spyShowLoadingCalled == true)
		XCTAssert(self.feedbackViewMock.spyStopLoadingCalled == true)
		XCTAssert(self.feedbackCoordinatorMock.outCloseFeedbackCalled == true)
		XCTAssert(self.feedbackInteractorMock.outSendFeedback.called == true)
		XCTAssert(self.feedbackInteractorMock.outSendFeedback.feedback?.message == "test message")
		XCTAssert(self.feedbackInteractorMock.outSendFeedback.feedback?.feedbackType == .feedback)
		XCTAssert(self.feedbackInteractorMock.outSendFeedback.feedback?.screenshot == nil)
		XCTAssert(self.feedbackViewMock.spyShowMessage.called == false)
	}

	func test_userDidTapSendFeedbackButton_feedbackSentHasScreenshot_whenAttachedScreenshot() {
		// ARRANGE
		self.feedbackViewMock.fakeMessage = "test message"
		self.feedbackInteractorMock.inResult = .success

		let image = UIImage()
		let editedImage = UIImage()
		self.screenshotInteractorMock.fakeScreenshot = Screenshot(image: image)
		self.feedbackViewMock.fakeEditedScreenshot = editedImage


		// ACT
		self.feedbackPresenter.viewDidLoad()
		self.feedbackPresenter.userDidTapAddFeedbackButton()
		self.feedbackPresenter.userDidChangedAttachScreenshot(attach: true)
		self.feedbackPresenter.userDidTapSendFeedbackButton()

		// ASSERT
		XCTAssert(self.feedbackViewMock.spyNeedMessageCalled == false)
		XCTAssert(self.feedbackViewMock.spyShowLoadingCalled == true)
		XCTAssert(self.feedbackViewMock.spyStopLoadingCalled == true)
		XCTAssert(self.feedbackCoordinatorMock.outCloseFeedbackCalled == true)
		XCTAssert(self.feedbackInteractorMock.outSendFeedback.called == true)
		XCTAssert(self.feedbackInteractorMock.outSendFeedback.feedback?.message == "test message")
		XCTAssert(self.feedbackInteractorMock.outSendFeedback.feedback?.feedbackType == .bug)
		XCTAssert(self.feedbackInteractorMock.outSendFeedback.feedback?.screenshot?.image == editedImage)
		XCTAssert(self.feedbackViewMock.spyShowMessage.called == false)
	}

	func test_userDidTapSendFeedbackButton_feedbackSentHasNoScreenshot_whenNoAttachedScreenshot() {
		// ARRANGE
		self.feedbackViewMock.fakeMessage = "test message"
		self.feedbackInteractorMock.inResult = .success

		let image = UIImage()
		self.screenshotInteractorMock.fakeScreenshot = Screenshot(image: image)
		self.feedbackPresenter.viewDidLoad()

		self.feedbackPresenter.userDidChangedAttachScreenshot(attach: false)

		// ACT
		self.feedbackPresenter.userDidTapSendFeedbackButton()

		// ASSERT
		XCTAssert(self.feedbackViewMock.spyNeedMessageCalled == false)
		XCTAssert(self.feedbackViewMock.spyShowLoadingCalled == true)
		XCTAssert(self.feedbackViewMock.spyStopLoadingCalled == true)
		XCTAssert(self.feedbackCoordinatorMock.outCloseFeedbackCalled == true)
		XCTAssert(self.feedbackInteractorMock.outSendFeedback.called == true)
		XCTAssert(self.feedbackInteractorMock.outSendFeedback.feedback?.message == "test message")
		XCTAssert(self.feedbackInteractorMock.outSendFeedback.feedback?.feedbackType == .bug)
		XCTAssert(self.feedbackInteractorMock.outSendFeedback.feedback?.screenshot == nil)
		XCTAssert(self.feedbackViewMock.spyShowMessage.called == false)
	}
	
	func test_userDidTapPreview_resultViewShowScreenshotNil_andStateChangedToPreview() {
		self.feedbackPresenter.userDidTapPreview()
		
		XCTAssert(self.feedbackViewMock.spyShowScreenshot.called == true)
		XCTAssert(self.feedbackViewMock.spyShowScreenshot.image == nil)
	}
	
	func test_userDidShake_resultShowOriginalScreenshot_whenPreviewModeIsSet() {
		let originalImage = UIImage()
		self.screenshotInteractorMock.fakeScreenshot = Screenshot(image: originalImage)
		
		
		self.feedbackPresenter.viewDidLoad()
		self.feedbackPresenter.userDidShake()
		
		XCTAssert(self.feedbackViewMock.spyShowScreenshot.called == true)
		XCTAssert(self.feedbackViewMock.spyShowScreenshot.image == originalImage)
	}
	
	func test_userDidShake_resultNoShowScreenshot_whenFormularyModeIsSet() {
		// Arrange
		let originalImage = UIImage()
		let editedImage = UIImage()
		self.screenshotInteractorMock.fakeScreenshot = Screenshot(image: originalImage)
		self.feedbackViewMock.fakeEditedScreenshot = editedImage
		
		// Act
		self.feedbackPresenter.userDidTapAddFeedbackButton()
		self.feedbackPresenter.userDidShake()
		
		// Assert
		XCTAssert(self.feedbackViewMock.spyShowScreenshot.called == false)
	}
	
	func test_userDidShake_resultShowOriginalScreenshot_whenFormularyModeIsSet_thenBackToPreview() {
		// Arrange
		let originalImage = UIImage()
		let editedImage = UIImage()
		self.screenshotInteractorMock.fakeScreenshot = Screenshot(image: originalImage)
		self.feedbackViewMock.fakeEditedScreenshot = editedImage
		
		// Act
		self.feedbackPresenter.viewDidLoad()
		self.feedbackPresenter.userDidTapAddFeedbackButton()
		self.feedbackPresenter.userDidTapPreview()
		self.feedbackPresenter.userDidShake()
		
		// Assert
		XCTAssert(self.feedbackViewMock.spyRestoreScreenshot.called == true)
		XCTAssert(self.feedbackViewMock.spyRestoreScreenshot.image == originalImage)
	}

}
