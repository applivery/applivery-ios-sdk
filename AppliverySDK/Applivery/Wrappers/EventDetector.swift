//
//  EventDetector.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 23/2/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


protocol EventDetector {
	func listenEvent(onDectention: () -> Void)
}

class ScreenshotDetector: EventDetector {
	
	func listenEvent(onDetection: () -> Void) {
		LogInfo("Applivery is listening for screenshot event")
		
		NSNotificationCenter.defaultCenter().addObserverForName(
				UIApplicationUserDidTakeScreenshotNotification,
				object: nil,
				queue: NSOperationQueue.mainQueue()) { _ in
					onDetection()
		}
	}
	
}
