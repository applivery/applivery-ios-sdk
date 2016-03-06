//
//  NSNotificationCenter+Applivery.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 6/3/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


extension NSNotificationCenter {
	
	class func keyboardWillShow(notificationHandler: (NSNotification) -> Void) {
		NSNotificationCenter.defaultCenter()
			.addObserverForName(
				UIKeyboardWillShowNotification,
				object: nil,
				queue: .mainQueue(),
				usingBlock: notificationHandler
		)
	}
	
	class func keyboardWillHide(notificationHandler: (NSNotification) -> Void) {
		NSNotificationCenter.defaultCenter()
			.addObserverForName(
				UIKeyboardWillHideNotification,
				object: nil,
				queue: .mainQueue(),
				usingBlock: notificationHandler
		)
	}
	
}
