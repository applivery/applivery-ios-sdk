//
//  Reachability.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez Agudo on 23/10/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation
import SystemConfiguration

class Wifi {
	
	class func isConnectedToWifi() -> Bool {
		var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
		zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
		zeroAddress.sin_family = sa_family_t(AF_INET)
		
		let defaultRouteReachabilityUnsafe = withUnsafePointer(to: &zeroAddress) {
			$0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
				SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
			}
		}
		
		guard let defaultRouteReachability = defaultRouteReachabilityUnsafe else {
			logWarn("Couldn't get default route recheability")
			return false
		}
		
		var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
		if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == false {
			return false
		}
		
		let isReachable = flags == .reachable
		let needsConnection = flags == .connectionRequired
		
		return isReachable && !needsConnection
		
	}
	
}
