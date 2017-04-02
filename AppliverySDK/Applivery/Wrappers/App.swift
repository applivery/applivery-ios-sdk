//
//  AppInfo.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 5/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation


// Wrapper for Application's operation

protocol AppProtocol {
	func bundleId() -> String
	func getVersion() -> String
	func getVersionName() -> String
	func getLanguage() -> String
	
	
	func openUrl(_ url: String) -> Bool
	func showLoading()
	func hideLoading()
	func showOtaAlert(_ message: String, downloadHandler: @escaping () -> Void)
	func showErrorAlert(_ message: String, retryHandler: @escaping () -> Void)
	func waitForReadyThen(_ onReady: @escaping () -> Void)
	func presentModal(_ viewController: UIViewController, animated: Bool)
}

extension AppProtocol {
	
	// Add default argument
	func presentModal(_ viewController: UIViewController, animated: Bool = true) {
		self.presentModal(viewController, animated: animated)
	}
	
}


class App: AppProtocol {

	private var alertOta: UIAlertController = UIAlertController()
	private var alertError: UIAlertController = UIAlertController()


	// MARK - Public Methods

	func bundleId() -> String {
		guard let bundleId = Bundle.main.bundleIdentifier else {
			logWarn("No bundle identifier found")
			return "no_id"
		}

		return bundleId
	}

	func getVersion() -> String {
		guard let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
			return "NO_VERSION_FOUND"
		}
		return version
	}

	func getVersionName() -> String {
		guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
			return "NO_VERSION_FOUND"
		}
		return version
	}

	func getLanguage() -> String {
		guard let language = (Locale.current as NSLocale).object(forKey: NSLocale.Key.languageCode) as? String else {
			return "NO_LANGUAGE_FOUND"
		}

		return language
	}

	func openUrl(_ urlString: String) -> Bool {
		logInfo("Opening \(urlString)")
		guard let url = URL(string: urlString) else { return false }
		UIApplication.shared.openURL(url)

		return true
	}

	func showLoading() {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
	}

	func hideLoading() {
		UIApplication.shared.isNetworkActivityIndicatorVisible = false
	}

	func showAlert(_ message: String) {
		let alert = UIAlertController(title: literal(.appName), message: message, preferredStyle: .alert)

		let actionLater = UIAlertAction(title: literal(.alertButtonOK), style: .cancel, handler: nil)
		alert.addAction(actionLater)

		let topVC = self.topViewController()

		topVC?.present(alert, animated: true, completion: nil)
	}

	func showOtaAlert(_ message: String, downloadHandler: @escaping () -> Void ) {
		self.alertOta = UIAlertController(title: literal(.appName), message: message, preferredStyle: .alert)

		let actionLater = UIAlertAction(title: literal(.alertButtonLater), style: .cancel, handler: nil)
		let actionDownload = UIAlertAction(title: literal(.alertButtonUpdate), style: .default) { _ in
			downloadHandler()
		}

		self.alertOta.addAction(actionLater)
		self.alertOta.addAction(actionDownload)

		let topVC = self.topViewController()

		topVC?.present(self.alertOta, animated: true, completion: nil)
	}

	func showErrorAlert(_ message: String, retryHandler: @escaping () -> Void) {
		self.alertError = UIAlertController(title: literal(.appName), message: message, preferredStyle: .alert)

		let actionCancel = UIAlertAction(title: literal(.alertButtonCancel), style: .cancel, handler: nil)
		let actionRetry = UIAlertAction(title: literal(.alertButtonRetry), style: .default) { _ in
			retryHandler()
		}

		self.alertError.addAction(actionCancel)
		self.alertError.addAction(actionRetry)

		let topVC = self.topViewController()
		topVC?.present(self.alertError, animated: true, completion: nil)
	}

	func waitForReadyThen(_ onReady: @escaping () -> Void) {
		runInBackground {
			self.sleepUntilReady()
			runOnMainThread(onReady)
		}
	}

	func presentModal(_ viewController: UIViewController, animated: Bool) {
		let topVC = self.topViewController()
		topVC?.present(viewController, animated: animated, completion: nil)
	}


	// MARK - Private Helpers

	fileprivate func sleepUntilReady() {
		while !self.rootIsReady() {
			Thread.sleep(forTimeInterval: 0.1)
		}
	}

	fileprivate func rootIsReady() -> Bool {
		let app = UIApplication.shared
		let window = app.keyWindow
		guard let rootVC = window?.rootViewController else { return false }

		return rootVC.isViewLoaded
	}

	fileprivate func topViewController() -> UIViewController? {
		let app = UIApplication.shared
		let window = app.keyWindow
		var rootVC = window?.rootViewController
		while let presentedController = rootVC?.presentedViewController {
			rootVC = presentedController
		}

		return rootVC
	}

}
