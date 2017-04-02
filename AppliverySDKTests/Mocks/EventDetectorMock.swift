//
//  EventDetectorMock.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 23/2/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation
@testable import Applivery


class EventDetectorMock: EventDetector {

	var spyListenEventCalled = false
	var spyEndListeningCalled = false
	var spyOnDetectionClosure: (() -> Void)!

	func listenEvent(_ onDetection: @escaping () -> Void) {
		self.spyListenEventCalled = true
		self.spyOnDetectionClosure = onDetection
	}

	func endListening() {
		self.spyEndListeningCalled = true
	}

}
