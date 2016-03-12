//
//  AppInfoMock.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 5/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import UIKit
@testable import Applivery


class AppMock: PApp {
	
	// Inputs
	var inVersion: String!
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
	
	
	func getVersion() -> String {
		return self.inVersion
	}
	
	func getLanguage() -> String {
		// DO WHEN NEEDED
		return ""
	}
	
	func openUrl(url: String) -> Bool {
		self.outOpenUrl = (true, url)
		return self.inOpenUrlResult
	}
	
	func showLoading() {
		self.outShowLoadingCalled = true
	}
	
	func hideLoading() {
		self.outHideLoadingCalled = true
	}

	func showOtaAlert(message: String, downloadHandler: () -> Void) {
		self.outOtaAlert = (true, message)
		self.outDownloadClosure = downloadHandler
	}
	
	func showErrorAlert(message: String, retryHandler: () -> Void) {
		self.outAlertError = (true, message)
		self.outRetryClosure = retryHandler
	}
	
	func waitForReadyThen(onReady: () -> Void) {
		self.outWaitForReadyCalled = true
		onReady()
	}
	
	func presentModal(viewController: UIViewController) {
		self.outPresentModal = (true, viewController)
	}
}
