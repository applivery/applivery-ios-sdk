//
//  EventDetector.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 23/2/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation
import UIKit


protocol EventDetector {
	func listenEvent(_ onDectention: @escaping () -> Void)
	func endListening()
}

class ScreenshotDetector: EventDetector {
	var observer: AnyObject?

	func listenEvent(_ onDetection: @escaping () -> Void) {
		guard GlobalConfig.shared.feedbackEnabled else { return }

		logInfo("Applivery is listening for screenshot event")

		self.observer = NotificationCenter.default
			.addObserver(
				forName: UIApplication.userDidTakeScreenshotNotification,
				object: nil,
				queue: OperationQueue.main) { _ in
					onDetection()
		}
	}

	func endListening() {
		guard let observer = self.observer else { return }

		logInfo("Applivery has stopped for screenshot event")

		NotificationCenter.default.removeObserver(observer)
	}

}
