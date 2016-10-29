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
	var inBundleID: String!
	var inVersion: String!
	var inVersionName: String!
	var inOpenUrlResult = false

	// Outputs
	var outOpenUrl = (called: false, url: "")
	var outOtaAlert = (called: false, message: "")
	var outAlertError = (called: false, message: "")
	var outWaitForReadyCalled = false
	var outPresentModal: (called: Bool, viewController: UIViewController?) = (false, nil)
	var outDownloadClosure: (() -> Void)?
	var outRetryClosure: (() -> Void)?
	var outShowLoadingCalled = false
	var outHideLoadingCalled = false


	func bundleId() -> String {
		return self.inBundleID
	}

	func getVersion() -> String {
		return self.inVersion
	}
	
	func getVersionName() -> String {
		return self.inVersionName
	}

	func getLanguage() -> String {
		// DO WHEN NEEDED
		return ""
	}

	func openUrl(_ url: String) -> Bool {
		self.outOpenUrl = (true, url)
		return self.inOpenUrlResult
	}

	func showLoading() {
		self.outShowLoadingCalled = true
	}

	func hideLoading() {
		self.outHideLoadingCalled = true
	}

	func showOtaAlert(_ message: String, downloadHandler: @escaping () -> Void) {
		self.outOtaAlert = (true, message)
		self.outDownloadClosure = downloadHandler
	}

	func showErrorAlert(_ message: String, retryHandler: @escaping () -> Void) {
		self.outAlertError = (true, message)
		self.outRetryClosure = retryHandler
	}

	func waitForReadyThen(_ onReady: @escaping () -> Void) {
		self.outWaitForReadyCalled = true
		onReady()
	}

	func presentModal(_ viewController: UIViewController) {
		self.outPresentModal = (true, viewController)
	}
}
