//
//  Ram.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez Agudo on 23/10/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation

// based on solution found: http://stackoverflow.com/questions/27556807/swift-pointer-problems-with-mach-task-basic-info

struct Ram {
	
	func memoryInUse() -> UInt64 {
		var info = mach_task_basic_info()
		var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
		
		let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
			$0.withMemoryRebound(to: integer_t.self, capacity: 1) {
				task_info(
					mach_task_self_,
					task_flavor_t(MACH_TASK_BASIC_INFO),
					$0,
					&count
				)
			}
		}
		
		if kerr == KERN_SUCCESS {
			return info.resident_size
			
		} else {
			logWarn("Error with task_info(): " +
				(String(cString: mach_error_string(kerr), encoding: String.Encoding.ascii) ?? "unknown error"))
			return 0
		}
	}
	
}
