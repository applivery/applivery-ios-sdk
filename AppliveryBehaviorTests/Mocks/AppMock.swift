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
    var stubBundleID: String = "NO BUNDLE ID SET"
    var stubSDKVersion: String = "NO VERSION SET"
    var stubBuildNumber: String = "NO VERSION SET"
    var stubVersion: String = "NO VERSION SET"
    var stubVersionName: String = "NO VERSION SET"
    var stubLanguage: String = "NO LANGUAGE SET"
    var stubOpenUrlResult = false

    // Outputs
    var spyOpenUrl = (called: false, url: "")
    var spyOtaAlert = (called: false, message: "")
    var spyForceUpdateCalled = false
    var spyAlertError = (called: false, message: "")
    var spyWaitForReadyCalled = false
    var spyPresentModal: (called: Bool, viewController: UIViewController?) = (false, nil)
    var spyDownloadClosure: (() -> Void)?
    var spyRetryClosure: (() -> Void)?
    var spyShowLoadingCalled = false
    var spyHideLoadingCalled = false
    var spyPresentFeedbackForm = false
    var spyLoginView = (called: false, message: "")
    var spyLoginCancelClosure: (() -> Void)?
    var spyLoginClosure: ((String, String) -> Void)?
    var spyShowLoginAlert = false
    var spyLoginAlertDownloadClosure: (() -> Void)?

    func bundleId() -> String {
        return self.stubBundleID
    }

    func getSDKVersion() -> String {
        return self.stubSDKVersion
    }

    func getBuildNumber() -> String {
        return self.stubBuildNumber
    }

    func getVersion() -> String {
        return self.stubVersion
    }

    func getVersionName() -> String {
        return self.stubVersionName
    }

    func getLanguage() -> String {
        return self.stubLanguage
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

    func showForceUpdate() {
        self.spyForceUpdateCalled = true
    }

    func showErrorAlert(_ message: String) {
        self.spyAlertError = (true, message)
    }

    func waitForReadyThen(_ onReady: @escaping () -> Void) {
        self.spyWaitForReadyCalled = true
        onReady()
    }

    func presentModal(_ viewController: UIViewController, animated: Bool) {
        self.spyPresentModal = (true, viewController)
    }

    func showLoginView(message: String, cancelHandler: @escaping () -> Void, loginHandler: @escaping (String, String) -> Void) {
        self.spyLoginView = (true, message)
        self.spyLoginCancelClosure = cancelHandler
        self.spyLoginClosure = loginHandler
    }

    func presentFeedbackForm() {
        self.spyPresentFeedbackForm = true
    }

    func topViewController() -> UIViewController? {
        return nil
    }

    func showOtaAlert(_ message: String, allowPostpone: Bool, downloadHandler: @escaping () -> Void, postponeHandler: @escaping () -> Void) {
        self.spyOtaAlert = (true, message)
        self.spyDownloadClosure = downloadHandler
        self.spyRetryClosure = postponeHandler
    }

    func showLoginAlert(isCancellable: Bool, downloadHandler: @escaping () -> Void) {
        self.spyShowLoginAlert = true
        self.spyLoginAlertDownloadClosure = downloadHandler
    }

    func showPostponeSelectionAlert(_ message: String, options: [TimeInterval], selectionHandler: @escaping (TimeInterval) -> Void) {
        self.spyOtaAlert = (true, message)
        if let firstOption = options.first {
            selectionHandler(firstOption)
        }
    }
}
