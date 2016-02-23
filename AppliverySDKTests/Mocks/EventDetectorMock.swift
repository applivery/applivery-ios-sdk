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

	var outListenEventCalled = false
	
	func listenEvent() {
		self.outListenEventCalled = true
	}
	
}
