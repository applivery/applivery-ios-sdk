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
			endpoint: "/api/feedback",
			method: "POST",
			bodyParams: [
				"app": config.appId ,
				"type": feedback.feedbackType.rawValue,
				"message": feedback.message,
				"packageInfo": [
					"name": app.bundleId(),
					"version": app.getVersion(),
					"versionName": app.getVersionName()
				],
				"deviceInfo": [
					"device": [
						"model": UIDevice.current.modelName,
						"vendor": "Apple",
						"type": UIDevice.current.model,
						"id": self.device.vendorId(),
						 "network": self.device.networkType(),
						 "resolution": self.device.resolution(),
						  "orientation": self.device.orientation(),
						 "ramFree": self.device.ramFree(),
						 "diskFree": self.device.diskFree()
					],
					"os": [
						"name": "iOS",
						"version": UIDevice.current.systemVersion
					]
				],
				"screenshot": screenshot
			]
		)
		
		self.setBatteryInfo()
		self.device.disableBatteryMonitoring()
		
		self.request?.sendAsync { response in
			if response.success {
				completionHandler(.success(true))
			} else {
				LogError(response.error)
				completionHandler(.error(NSError.UnexpectedError()))
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
		let _ = self.request?.bodyParams.updateValue(deviceInfo, forKey: "deviceInfo")
	}
	
}
