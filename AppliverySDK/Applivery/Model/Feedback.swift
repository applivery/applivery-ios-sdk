//
//  Feedback.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 13/3/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


enum FeedbackType: String {
	case bug = "bug"
	case feedback = "feedback"
}


struct Feedback {

	let feedbackType: FeedbackType
	let message: String
	let screenshot: Screenshot?

}
