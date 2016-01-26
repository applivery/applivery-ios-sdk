//
//  AppInfo.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 5/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation


//! Wrapper for Application's operation

protocol PApp {
	func getVersion() -> String
	func getLanguage() -> String
	func openUrl(url: String)
	func showLoading()
	func hideLoading()
	func showOtaAlert(message: String, downloadHandler: () -> Void)
	func showErrorAlert(message: String, retryHandler: () -> Void)
	func waitForReadyThen(onReady: () -> Void)
	func presentModal(viewController: UIViewController)
}


class App: PApp {
	
	private var alertOta: UIAlertController?
	private var alertError: UIAlertController?
	
	
	// MARK - Public Methods
	
	func getVersion() -> String {
		let version = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as! String
		return version
	}
	
	func getLanguage() -> String {
		return NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode)! as! String
	}
	
	func openUrl(url: String) {
		LogInfo("Opening \(url)")
		UIApplication.sharedApplication().openURL(NSURL(string: url)!)
	}
	
	func showLoading() {
		UIApplication.sharedApplication().networkActivityIndicatorVisible = true
	}
	
	func hideLoading() {
		UIApplication.sharedApplication().networkActivityIndicatorVisible = false
	}
	
	func showOtaAlert(message: String, downloadHandler: () -> Void ) {
		self.alertOta = UIAlertController(title: Localize("sdk_name"), message: message, preferredStyle: .Alert)
		
		let actionLater = UIAlertAction(title: Localize("alert_button_later"), style: .Cancel, handler: nil)
		let actionDownload = UIAlertAction(title: Localize("alert_button_update"), style: .Default) { _ in
			downloadHandler()
		}

		self.alertOta?.addAction(actionLater)
		self.alertOta?.addAction(actionDownload)
		
		let topVC = self.topViewController()
		
		topVC?.presentViewController(self.alertOta!, animated: true, completion: nil)
	}
	
	func showErrorAlert(message: String, retryHandler: () -> Void) {
		self.alertError = UIAlertController(title: Localize("sdk_name"), message: message, preferredStyle: .Alert)
		
		let actionCancel = UIAlertAction(title: Localize("alert_button_cancel"), style: .Cancel, handler: nil)
		let actionRetry = UIAlertAction(title: Localize("alert_button_retry"), style: .Default) { _ in
			retryHandler()
		}
		
		self.alertError?.addAction(actionCancel)
		self.alertError?.addAction(actionRetry)
		
		let topVC = self.topViewController()
		topVC?.presentViewController(self.alertError!, animated: true, completion: nil)
	}

	func waitForReadyThen(onReady: () -> Void) {
		runInBackground {
			self.sleepUntilReady()
			runOnMainThread(onReady)
		}
	}
	
	func presentModal(viewController: UIViewController) {
		let topVC = self.topViewController()
		topVC?.presentViewController(viewController, animated: true, completion: nil)
	}
	
	
	// MARK - Private Helpers
	
	private func sleepUntilReady() {
		while !self.rootIsReady() {
			NSThread.sleepForTimeInterval(0.1)
		}
	}
	
	private func rootIsReady() -> Bool {
		let app = UIApplication.sharedApplication()
		let window = app.keyWindow
		guard let rootVC = window?.rootViewController else { return false }
		
		return rootVC.isViewLoaded()
	}
	
	private func topViewController() -> UIViewController? {
		let app = UIApplication.sharedApplication()
		let window = app.keyWindow
		var rootVC = window?.rootViewController
		while let presentedController = rootVC?.presentedViewController {
			rootVC = presentedController
		}
		
		return rootVC
	}

}
