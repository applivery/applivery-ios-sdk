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
	
	var fakeModel: String!
	var fakeType: String!
	var fakeSystemVersion: String!
	var fakeVendorId: String!
	var fakeBatteryLevel: Int!
	var fakeBatteryState: Bool?
	var fakeNetworkType: String!
	var fakeResolution: String!
	var fakeOrientation: String!
	var fakeRamUsed: String!
	var fakeRamTotal: String!
	var fakeDiskFree: String!
	
	
	func enableBatteryMonitoring() {
		self.enableBatteryMonitoringCalled = true
	}
	
	func disableBatteryMonitoring() {
		self.disableBatteryMonitoringCalled = true
	}
	
	func model() -> String {
		return self.fakeModel
	}
	
	func type() -> String {
		return self.fakeType
	}
	
	func systemVersion() -> String {
		return self.fakeSystemVersion
	}
	
	func vendorId() -> String {
		return self.fakeVendorId
	}
	
	func batteryLevel() -> Int {
		return self.fakeBatteryLevel
	}
	
	func batteryState() -> Bool? {
		return self.fakeBatteryState
	}
	
	func networkType() -> String {
		return self.fakeNetworkType
	}
	
	func resolution() -> String {
		return self.fakeResolution
	}
	
	func orientation() -> String {
		return self.fakeOrientation
	}
	
	func ramUsed() -> String {
		return self.fakeRamUsed
	}
	
	func ramTotal() -> String {
		return self.fakeRamTotal
	}
	
	func diskFree() -> String {
		return self.fakeDiskFree
	}
	
}
