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
	
	var inModel: String!
	var inType: String!
	var inSystemVersion: String!
	var inVendorId: String!
	var inBatteryLevel: Int!
	var inBatteryState: Bool?
	var inNetworkType: String!
	var inResolution: String!
	var inOrientation: String!
	var inRamUsed: String!
	var inRamTotal: String!
	var inDiskFree: String!
	
	
	func enableBatteryMonitoring() {
		self.enableBatteryMonitoringCalled = true
	}
	
	func disableBatteryMonitoring() {
		self.disableBatteryMonitoringCalled = true
	}
	
	func model() -> String {
		return self.inModel
	}
	
	func type() -> String {
		return self.inType
	}
	
	func systemVersion() -> String {
		return self.inSystemVersion
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
	
	func ramUsed() -> String {
		return self.inRamUsed
	}
	
	func ramTotal() -> String {
		return self.inRamTotal
	}
	
	func diskFree() -> String {
		return self.inDiskFree
	}
	
}
