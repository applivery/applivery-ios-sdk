//
//  FeedbackCoordinatorMock.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 28/2/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation
@testable import Applivery


class FeedbackCoordinatorMock: PFeedbackCoordinator {

	var outShowFeedbackCalled = false
	var outCloseFeedbackCalled = false


	func showFeedack() {
		self.outShowFeedbackCalled = true
	}

	func closeFeedback() {
		self.outCloseFeedbackCalled = true
	}

}
