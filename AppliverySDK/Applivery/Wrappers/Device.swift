//
//  Device.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez Agudo on 23/10/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation

protocol DeviceProtocol {
	func vendorId() -> String
	func enableBatteryMonitoring()
	func disableBatteryMonitoring()
	func batteryLevel() -> Int
	func batteryState() -> Bool?
}

struct Device: DeviceProtocol {
	
	func vendorId() -> String {
		return UIDevice.current.identifierForVendor?.uuidString ?? "NO_ID"
	}
	
	func enableBatteryMonitoring() {
		UIDevice.current.isBatteryMonitoringEnabled = true
	}
	
	func disableBatteryMonitoring() {
		UIDevice.current.isBatteryMonitoringEnabled = false
	}
	
	func batteryLevel() -> Int {
		return Int(UIDevice.current.batteryLevel * 100)
	}
	
	func batteryState() -> Bool? {
		switch UIDevice.current.batteryState {
		case .charging, .full: return true
		case .unplugged: return false
		case .unknown: return nil
		}
	}
	
}
