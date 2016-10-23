//
//  DeviceMock.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez Agudo on 23/10/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation
@testable import Applivery


class DeviceMock: DeviceProtocol {
	
	var enableBatteryMonitoringCalled = false
	var disableBatteryMonitoringCalled = false
	
	var inVendorId: String!
	var inBatteryLevel: Int!
	var inBatteryState: Bool?
	var inNetworkType: String!
	var inResolution: String!
	var inOrientation: String!
	var inRamFree: String!
	var inDiskFree: String!
	
	
	func enableBatteryMonitoring() {
		self.enableBatteryMonitoringCalled = true
	}
	
	func disableBatteryMonitoring() {
		self.disableBatteryMonitoringCalled = true
	}
	
	func vendorId() -> String {
		return self.inVendorId
	}
	
	func batteryLevel() -> Int {
		return self.inBatteryLevel
	}
	
	func batteryState() -> Bool? {
		return self.inBatteryState
	}
	
	func networkType() -> String {
		return self.inNetworkType
	}
	
	func resolution() -> String {
		return self.inResolution
	}
	
	func orientation() -> String {
		return self.inOrientation
	}
	
	func ramFree() -> String {
		return self.inRamFree
	}
	
	func diskFree() -> String {
		return self.inDiskFree
	}
	
}
