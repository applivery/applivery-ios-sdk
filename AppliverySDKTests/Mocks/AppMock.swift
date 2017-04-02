//
//  AppInfoMock.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 5/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import UIKit
@testable import Applivery


class AppMock: AppProtocol {

	// Inputs
	var stubBundleID: String!
	var stubVersion: String!
	var stubVersionName: String!
	var stubOpenUrlResult = false

	// Outputs
	var spyOpenUrl = (called: false, url: "")
	var spyOtaAlert = (called: false, message: "")
	var spyAlertError = (called: false, message: "")
	var spyWaitForReadyCalled = false
	var spyPresentModal: (called: Bool, viewController: UIViewController?) = (false, nil)
	var spyDownloadClosure: (() -> Void)?
	var spyRetryClosure: (() -> Void)?
	var spyShowLoadingCalled = false
	var spyHideLoadingCalled = false


	func bundleId() -> String {
		return self.stubBundleID
	}

	func getVersion() -> String {
		return self.stubVersion
	}
	
	func getVersionName() -> String {
		return self.stubVersionName
	}

	func getLanguage() -> String {
		// DO WHEN NEEDED
		return ""
	}

	func openUrl(_ url: String) -> Bool {
		self.spyOpenUrl = (true, url)
		return self.stubOpenUrlResult
	}

	func showLoading() {
		self.spyShowLoadingCalled = true
	}

	func hideLoading() {
		self.spyHideLoadingCalled = true
	}

	func showOtaAlert(_ message: String, downloadHandler: @escaping () -> Void) {
		self.spyOtaAlert = (true, message)
		self.spyDownloadClosure = downloadHandler
	}

	func showErrorAlert(_ message: String, retryHandler: @escaping () -> Void) {
		self.spyAlertError = (true, message)
		self.spyRetryClosure = retryHandler
	}

	func waitForReadyThen(_ onReady: @escaping () -> Void) {
		self.spyWaitForReadyCalled = true
		onReady()
	}

	func presentModal(_ viewController: UIViewController, animated: Bool) {
		self.spyPresentModal = (true, viewController)
	}
}
