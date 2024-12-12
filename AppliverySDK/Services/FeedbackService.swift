//
//  FeedbackService.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 13/3/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation

struct StatusCall: Decodable {
    let status: Bool
}

protocol FeedbackServiceProtocol {
    func postFeedback(_ feedback: Feedback) async throws
    func postVideoFeedback(inputFeedback: Feedback) async throws
}

class FeedbackService: FeedbackServiceProtocol {
	
	let app: AppProtocol
	let device: DeviceProtocol
	let config: GlobalConfig
    
    private let client: APIClientProtocol
	
    init(
        app: AppProtocol,
        device: DeviceProtocol,
        config: GlobalConfig,
        client: APIClientProtocol = APIClient()
) {
		self.app = app
		self.device = device
		self.config = config
        self.client = client

	}
	
    func postFeedback(_ feedback: Feedback) async throws {
        let screenshot = feedback.screenshot?.base64() ?? ""
        let feedbackData: FeedbackData = .init(
            type: feedback.feedbackType.rawValue,
            message: feedback.message,
            packageInfo: .init(app: app),
            deviceInfo: .init(device: device),
            screenshot: "data:image/jpeg;base64,\(screenshot)",
            hasVideo: false
        )
        
        let endpoint: AppliveryEndpoint = .feedback(feedbackData)
        let _: StatusCall = try await client.fetch(endpoint: endpoint)
    }
    
    func postVideoFeedback(inputFeedback: Feedback) async throws {
        let feedbackData: FeedbackData = .init(
            type: inputFeedback.feedbackType.rawValue,
            message: inputFeedback.message,
            packageInfo: .init(app: app),
            deviceInfo: .init(device: device),
            screenshot: nil,
            hasVideo: true
        )
        
        let endpoint: AppliveryEndpoint = .feedback(feedbackData)
        
        self.device.disableBatteryMonitoring()
        
        Task {
            do {
                let videoURL: VideoFile = try await client.fetch(endpoint: endpoint)
                if let destinationVideoURL = URL(string: videoURL.data.videoFile.location), let localURL = inputFeedback.videoURL {
                    try await client.uploadVideo(localFileURL: localURL, to: destinationVideoURL)
                }
            } catch {
                logError(error as NSError)
            }
        }
    }
	
	
	// MARK: - Private Helpers
	
//	private func setBatteryInfo() {
//		guard
//			let batteryState = self.device.batteryState(),
//			var deviceInfo = self.request?.bodyParams["deviceInfo"] as? [String: Any],
//			var device = deviceInfo["device"] as? [String: Any]
//			else { return }
//		
//		device.updateValue(self.device.batteryLevel(), forKey: "battery")
//		device.updateValue(batteryState, forKey: "batteryStatus")
//		deviceInfo.updateValue(device, forKey: "device")
//		_ = self.request?.bodyParams.updateValue(deviceInfo, forKey: "deviceInfo")
//	}
	
}
