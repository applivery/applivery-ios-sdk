//
//  Device.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez Agudo on 23/10/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation
import CoreTelephony
import UIKit

protocol DeviceProtocol {
	func model() -> String
	func type() -> String
	func systemVersion() -> String
	func systemName() -> String
	func vendorId() -> String
	func enableBatteryMonitoring()
	func disableBatteryMonitoring()
	func batteryLevel() -> Int
	func batteryState() -> Bool?
	func networkType() -> String
	func resolution() -> String
	func orientation() -> String
	func ramUsed() -> String
	func ramTotal() -> String
	func diskFree() -> String
}

struct Device: DeviceProtocol {
	
	func model() -> String {
		return UIDevice.current.modelName
	}
	
	func type() -> String {
		return UIDevice.current.model
	}
	
	func systemVersion() -> String {
		return UIDevice.current.systemVersion
	}
	
	func systemName() -> String {
		return UIDevice.current.systemName
	}
	
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
		@unknown default: return nil
		}
	}

	func networkType() -> String {
		if Wifi.isConnectedToWifi() {
			return "wifi"
		}
		
		let networkInfo = CTTelephonyNetworkInfo()
		let carrierType = networkInfo.currentRadioAccessTechnology
		switch carrierType {
		
		case CTRadioAccessTechnologyGPRS?,
		     CTRadioAccessTechnologyEdge?,
		     CTRadioAccessTechnologyCDMA1x?:
			return "gprs"
		
		case CTRadioAccessTechnologyWCDMA?,
		     CTRadioAccessTechnologyHSDPA?,
		     CTRadioAccessTechnologyHSUPA?,
		     CTRadioAccessTechnologyCDMAEVDORev0?,
		     CTRadioAccessTechnologyCDMAEVDORevA?,
		     CTRadioAccessTechnologyCDMAEVDORevB?,
		     CTRadioAccessTechnologyeHRPD?:
			return "3g"
		
		case CTRadioAccessTechnologyLTE?:
			return "4g"
		
		default:
			return "no connected"
		}
	}
	
	func resolution() -> String {
		let width = UIScreen.main.bounds.width * UIScreen.main.scale
		let height = UIScreen.main.bounds.height * UIScreen.main.scale
		
		return "\(Int(width))x\(Int(height))"
	}
	
	func orientation() -> String {
		if UIApplication.shared.statusBarOrientation.isLandscape {
			return "landscape"
		} else {
			return "portrait"
		}
	}
	
	func ramUsed() -> String {
		let used = CGFloat(Ram().memoryInUse())
		let usedInKB = used / 1000
		let usedInMB = usedInKB / 1000
		
		return "\(Int(usedInMB))"
	}
	
	func ramTotal() -> String {
		let total = CGFloat(ProcessInfo.processInfo.physicalMemory)
		let totalInKB = total / 1000
		let totalInMB = totalInKB / 1000
		
		return "\(Int(totalInMB))"
	}

	func diskFree() -> String {
		let free = CGFloat(DiskStatus.freeDiskSpaceInBytes)
		let total = CGFloat(DiskStatus.totalDiskSpaceInBytes)
		let diskFreePercent = (free / total) * 100
		
		return "\(Int(diskFreePercent))"
	}

	
}
