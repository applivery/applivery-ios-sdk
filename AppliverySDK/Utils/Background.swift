//
//  Background.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 6/12/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation

func runInBackground(_ code: @escaping () -> Void) {
	DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: code)
}

func runOnMainThreadAsync(_ code: @escaping () -> Void) {
	DispatchQueue.main.async(execute: code)
}

func runOnMainThreadSynced(_ code: @escaping () -> Void) {
	DispatchQueue.main.sync(execute: code)
}

func sleep(for seconds: TimeInterval) {
	Thread.sleep(forTimeInterval: seconds)
}
