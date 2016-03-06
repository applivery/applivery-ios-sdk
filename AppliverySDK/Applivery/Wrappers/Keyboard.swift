//
//  Keyboard.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 6/3/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


class Keyboard {
	
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
	
	class func keyboardSize(notification: NSNotification) -> CGSize? {
		guard
			let info = notification.userInfo,
			let frame = info[UIKeyboardFrameEndUserInfoKey] as? NSValue
			else { return nil }
		
		return frame.CGRectValue().size
	}
	
	class func keyboardAnimationDuration(notification: NSNotification) -> NSTimeInterval {
		guard
			let info = notification.userInfo,
			let value = info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber
			else {
				LogWarn("Couldn't get keyboard animation duration")
				return 0
		}
		
		return value.doubleValue
	}
	
	class func keyboardAnimationCurve(notification: NSNotification) -> UIViewAnimationOptions {
		guard
			let info = notification.userInfo,
			let curve = info[UIKeyboardAnimationCurveUserInfoKey] as? UIViewAnimationCurve
			else {
				LogWarn("Couldn't get keyboard animation curve")
				return .CurveEaseIn
		}
		
		switch curve {
		case .EaseInOut:
			return .CurveEaseInOut
		case .EaseIn:
			return .CurveEaseIn
		case .EaseOut:
			return .CurveEaseOut
		case .Linear:
			return .CurveLinear
		}
		
	}
	
}