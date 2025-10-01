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
		self.observer = NotificationCenter.default
			.addObserver(
				forName: UIApplication.userDidTakeScreenshotNotification,
				object: nil,
				queue: OperationQueue.main) { _ in
                    if ScreenRecorderManager.shared.isRecording {
                        logInfo("A screenshot was detected but the device is also recording video and was ignored.")
                        return
                    }
					onDetection()
		}
        logInfo("Applivery is listening for screenshot event")
	}

	func endListening() {
		guard let observer = self.observer else { return }
		NotificationCenter.default.removeObserver(observer)
        logInfo("Applivery has stopped for screenshot event")
	}
}

class BackgroundDetector: EventDetector {
    var observer: AnyObject?

    func listenEvent(_ onDetection: @escaping () -> Void) {
        guard GlobalConfig.shared.isForegroundObserverAdded == false else { return }
        self.observer = NotificationCenter.default
            .addObserver(
                forName: UIApplication.willEnterForegroundNotification,
                object: nil,
                queue: OperationQueue.main) { _ in
                    onDetection()
        }
        GlobalConfig.shared.isForegroundObserverAdded = true
        logInfo("Background updates enabled")
    }

    func endListening() {
        guard GlobalConfig.shared.isForegroundObserverAdded else { return }
        guard let observer else { return }
        NotificationCenter.default.removeObserver(observer)
        GlobalConfig.shared.isCheckForUpdatesBackgroundEnabled = false
        logInfo("Applivery has stopped for foreground event")
    }
}
