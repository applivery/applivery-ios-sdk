//
//  Background.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 6/12/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation

func runInBackground(code: () -> Void) {
	dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), code)
}

func runOnMainThread(code: () -> Void) {
	dispatch_async(dispatch_get_main_queue(), code)
}