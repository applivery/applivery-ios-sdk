//
//  Keyboard.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 6/3/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation
import UIKit

class Keyboard {

	class func willShow(_ notificationHandler: @escaping (Notification) -> Void) {
		self.keyboardEvent(UIResponder.keyboardWillShowNotification.rawValue, notificationHandler: notificationHandler)
	}

	class func didShow(_ notificationHandler: @escaping (Notification) -> Void) {
		self.keyboardEvent(UIResponder.keyboardDidShowNotification.rawValue, notificationHandler: notificationHandler)
	}

	class func willHide(_ notificationHandler: @escaping (Notification) -> Void) {
		self.keyboardEvent(UIResponder.keyboardWillHideNotification.rawValue, notificationHandler: notificationHandler)
	}
	
	class func didHide(_ notificationHandler: @escaping (Notification) -> Void) {
		self.keyboardEvent(UIResponder.keyboardDidHideNotification.rawValue, notificationHandler: notificationHandler)
	}

	class func size(_ notification: Notification) -> CGSize? {
		guard
			let info = (notification as NSNotification).userInfo,
			let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
			else { return nil }

		let size = CGSize(
			width: keyboardFrame.width,
			height: keyboardFrame.height - Layout.safeAreaButtomHeight()
		)
		
		return size
	}

	class func animationDuration(_ notification: Notification) -> TimeInterval {
		guard
			let info = (notification as NSNotification).userInfo,
			let value = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber
			else {
				logWarn("Couldn't get keyboard animation duration")
				return 0
		}

		return value.doubleValue
	}

	class func animationCurve(_ notification: Notification) -> UIView.AnimationOptions {
		guard
			let info = (notification as NSNotification).userInfo,
			let curveInt = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
			let curve = UIView.AnimationCurve(rawValue: curveInt)
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

extension UIView.AnimationCurve {
	func toOptions() -> UIView.AnimationOptions {
		return UIView.AnimationOptions(rawValue: UInt(rawValue << 16))
	}
}
