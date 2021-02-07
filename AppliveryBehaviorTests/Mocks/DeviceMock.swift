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
	
	var fakeModel: String = "NO VALUE SET"
	var fakeType: String = "NO VALUE SET"
	var fakeSystemVersion: String = "NO VALUE SET"
	var fakeSystemName: String = "NO VALUE SET"
	var fakeVendorId: String = "NO VALUE SET"
	var fakeBatteryLevel: Int!
	var fakeBatteryState: Bool?
	var fakeNetworkType: String = "NO VALUE SET"
	var fakeResolution: String = "NO VALUE SET"
	var fakeOrientation: String = "NO VALUE SET"
	var fakeRamUsed: String = "NO VALUE SET"
	var fakeRamTotal: String = "NO VALUE SET"
	var fakeDiskFree: String = "NO VALUE SET"
	
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
	
	func systemName() -> String {
		return self.fakeSystemName
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
