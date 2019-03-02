//
//  FeedbackService.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 13/3/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation

protocol PFeedbackService {
	func postFeedback(_ feedback: Feedback, completionHandler: @escaping (Result<Bool, NSError>) -> Void)
}

class FeedbackService: PFeedbackService {
	
	let app: AppProtocol
	let device: DeviceProtocol
	let config: GlobalConfig
	var request: Request?
	
	init(app: AppProtocol, device: DeviceProtocol, config: GlobalConfig) {
		self.app = app
		self.device = device
		self.config = config
	}
	
	func postFeedback(_ feedback: Feedback, completionHandler: @escaping (Result<Bool, NSError>) -> Void) {
		self.device.enableBatteryMonitoring()
		let screenshot = feedback.screenshot?.base64() ?? ""
		
		self.request = Request(
			endpoint: "/v1/feedback",
			method: "POST",
			bodyParams: [
				"type": feedback.feedbackType.rawValue,
				"message": feedback.message,
				"packageInfo": [
					"name": self.app.bundleId(),
					"version": self.app.getVersion(),
					"versionName": self.app.getVersionName()
				],
				"deviceInfo": [
					"device": [
						"model": self.device.model(),
						"vendor": "Apple",
						"type": self.device.type(),
//						"id": self.device.vendorId(),
						"network": self.device.networkType(),
						"resolution": self.device.resolution(),
						"orientation": self.device.orientation(),
						"ramUsed": self.device.ramUsed(),
						"ramTotal": self.device.ramTotal(),
						"diskFree": self.device.diskFree()
					],
					"os": [
						"name": "ios",
						"version": self.device.systemVersion()
					]
				],
				"screenshot": "data:image/jpeg;base64,\(screenshot)"
			]
		)
		
		self.setBatteryInfo()
		self.device.disableBatteryMonitoring()
		
		self.request?.sendAsync { response in
			if response.success {
				completionHandler(.success(true))
			} else {
				logError(response.error)
				LoginManager().parse(
					error: response.error,
					retry: { self.postFeedback(feedback, completionHandler: completionHandler) },
					next: {	completionHandler(.error(NSError.unexpectedError()))}
				)
			}
		}
	}
	
	
	// MARK: - Private Helpers
	
	private func setBatteryInfo() {
		guard
			let batteryState = self.device.batteryState(),
			var deviceInfo = self.request?.bodyParams["deviceInfo"] as? [String: Any],
			var device = deviceInfo["device"] as? [String: Any]
			else { return }
		
		device.updateValue(self.device.batteryLevel(), forKey: "battery")
		device.updateValue(batteryState, forKey: "batteryStatus")
		deviceInfo.updateValue(device, forKey: "device")
		_ = self.request?.bodyParams.updateValue(deviceInfo, forKey: "deviceInfo")
	}
	
}
