//
//  FeedbackPresenter.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 28/2/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


protocol FeedbackView {
	
}


class FeedbackPresenter {
	
	var view: FeedbackView!
	var feedbackInteractor: FeedbackInteractor!
	var feedbackCoordinator: FeedbackCoordinator!
	
	
	func userDidTapCloseButton() {
		self.feedbackCoordinator.closeFeedback()
	}
	
}