//
//  Keyboard.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 6/3/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


class Keyboard {

	class func willShow(_ notificationHandler: @escaping (Notification) -> Void) {
		self.keyboardEvent(NSNotification.Name.UIKeyboardWillShow.rawValue, notificationHandler: notificationHandler)
	}

	class func didShow(_ notificationHandler: @escaping (Notification) -> Void) {
		self.keyboardEvent(NSNotification.Name.UIKeyboardDidShow.rawValue, notificationHandler: notificationHandler)
	}

	class func willHide(_ notificationHandler: @escaping (Notification) -> Void) {
		self.keyboardEvent(NSNotification.Name.UIKeyboardWillHide.rawValue, notificationHandler: notificationHandler)
	}
	
	class func didHide(_ notificationHandler: @escaping (Notification) -> Void) {
		self.keyboardEvent(NSNotification.Name.UIKeyboardDidHide.rawValue, notificationHandler: notificationHandler)
	}

	class func size(_ notification: Notification) -> CGSize? {
		guard
			let info = (notification as NSNotification).userInfo,
			let frame = info[UIKeyboardFrameEndUserInfoKey] as? NSValue
			else { return nil }

		return frame.cgRectValue.size
	}

	class func animationDuration(_ notification: Notification) -> TimeInterval {
		guard
			let info = (notification as NSNotification).userInfo,
			let value = info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber
			else {
				logWarn("Couldn't get keyboard animation duration")
				return 0
		}

		return value.doubleValue
	}

	class func animationCurve(_ notification: Notification) -> UIViewAnimationOptions {
		guard
			let info = (notification as NSNotification).userInfo,
			let curveInt = info[UIKeyboardAnimationCurveUserInfoKey] as? Int,
			let curve = UIViewAnimationCurve(rawValue: curveInt)
			else {
				logWarn("Couldn't get keyboard animation curve")
				return .curveEaseIn
		}

		return curve.toOptions()
	}


	// MARK: - Private Helpers

	private class func keyboardEvent(_ event: String, notificationHandler: @escaping (Notification) -> Void) {
		_ = NotificationCenter.default
			.addObserver(
				forName: NSNotification.Name(rawValue: event),
				object: nil,
				queue: nil,
				using: notificationHandler
		)
	}

}

extension UIViewAnimationCurve {
	func toOptions() -> UIViewAnimationOptions {
		return UIViewAnimationOptions(rawValue: UInt(rawValue << 16))
	}
}
