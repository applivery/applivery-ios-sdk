//
//  FeedbackService.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 13/3/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


enum FeedbackServiceResult {
	case Success
	case Error(NSError)
}


class FeedbackService {
	
	func postFeedback(feedback: Feedback, completionHandler: FeedbackServiceResult -> Void) {
		let request = Request()
		request.endpoint = "/api/feedback"
		request.method = "POST"
		
		let app = App()
		let screenshot = feedback.screenshot?.base64() ?? ""
			
		request.bodyParams = [
			"app": GlobalConfig.shared.appId,
			"type": feedback.feedbackType.rawValue,
			"message": feedback.message,
			"packageInfo": [
				"name": app.bundleId(),
				"version": app.getVersion(),
				"versionName": app.getVersionName()
			],
			"deviceInfo": [
				"device": [
					"model": UIDevice.currentDevice().modelName,
					"vendor": "Apple",
					"type": UIDevice.currentDevice().model
				],
				"os": [
					"name": "iOS",
					"version": UIDevice.currentDevice().systemVersion
				]
			],
			"screenshot": screenshot
		]
		
		
		request.sendAsync { response in
			if response.success {
				completionHandler(.Success)
			}
			else {
				LogError(response.error)
				completionHandler(.Error(NSError.UnexpectedError()))
			}
		}
	}
	
}