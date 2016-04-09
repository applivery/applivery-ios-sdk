//
//  Keyboard.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 6/3/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


class Keyboard {
	
	class func willShow(notificationHandler: (NSNotification) -> Void) {
		self.keyboardEvent(UIKeyboardWillShowNotification, notificationHandler: notificationHandler)
	}
	
	class func didShow(notificationHandler: (NSNotification) -> Void) {
		self.keyboardEvent(UIKeyboardDidShowNotification, notificationHandler: notificationHandler)
	}
	
	class func willHide(notificationHandler: (NSNotification) -> Void) {
		self.keyboardEvent(UIKeyboardWillHideNotification, notificationHandler: notificationHandler)
	}
	
	class func size(notification: NSNotification) -> CGSize? {
		guard
			let info = notification.userInfo,
			let frame = info[UIKeyboardFrameEndUserInfoKey] as? NSValue
			else { return nil }
		
		return frame.CGRectValue().size
	}
	
	class func animationDuration(notification: NSNotification) -> NSTimeInterval {
		guard
			let info = notification.userInfo,
			let value = info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber
			else {
				LogWarn("Couldn't get keyboard animation duration")
				return 0
		}
		
		return value.doubleValue
	}
	
	class func animationCurve(notification: NSNotification) -> UIViewAnimationOptions {
		guard
			let info = notification.userInfo,
			let curveInt = info[UIKeyboardAnimationCurveUserInfoKey] as? Int,
			let curve = UIViewAnimationCurve(rawValue: curveInt)
			else {
				LogWarn("Couldn't get keyboard animation curve")
				return .CurveEaseIn
		}
		
		return curve.toOptions()
	}
	
	
	// MARK - Private Helpers
	
	private class func keyboardEvent(event: String, notificationHandler: (NSNotification) -> Void) {
		NSNotificationCenter.defaultCenter()
			.addObserverForName(
				event,
				object: nil,
				queue: .mainQueue(),
				usingBlock: notificationHandler
		)
	}
	
}

extension UIViewAnimationCurve {
	func toOptions() -> UIViewAnimationOptions {
		return UIViewAnimationOptions(rawValue: UInt(rawValue << 16))
	}
}