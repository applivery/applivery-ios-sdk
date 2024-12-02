//
//  AppInfo.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 5/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation
import UIKit

// Wrapper for Application's operation

protocol AppProtocol {
	func bundleId() -> String
	func getSDKVersion() -> String
	func getVersion() -> String
	func getVersionName() -> String
	func getLanguage() -> String
	func openUrl(_ url: String) -> Bool
	func showLoading()
	func hideLoading()
	func showOtaAlert(_ message: String, downloadHandler: @escaping () -> Void)
    func showForceUpdate()
	func showErrorAlert(_ message: String, retryHandler: @escaping () -> Void)
	func waitForReadyThen(_ onReady: @escaping () -> Void)
	func presentModal(_ viewController: UIViewController, animated: Bool)
    func presentFeedbackForm()
	func showLoginView(message: String, cancelHandler: @escaping () -> Void, loginHandler: @escaping (_ user: String, _ password: String) -> Void)
}

extension AppProtocol {
	
	// Add default argument
	func presentModal(_ viewController: UIViewController, animated: Bool = true) {
		self.presentModal(viewController, animated: animated)
	}
	
}


class App: AppProtocol {
	
	private lazy var alertOta: UIAlertController = UIAlertController()
	private lazy var alertError: UIAlertController = UIAlertController()
	private lazy var alertLogin: UIAlertController = UIAlertController()
	
	
	// MARK: - Public Methods
	
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
	
	func getSDKVersion() -> String {
        Applivery.sdkVersion
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
		UIApplication.shared.open(url)
		
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
    
    func showForceUpdate() {
//        if let updateVC = UpdateVC.viewController() {
//            updateVC.presenter = UpdatePresenter(
//                updateInteractor: Configurator.updateInteractor(),
//                view: updateVC
//            )
//            //updateVC.presenter.updateInteractor.output = updateVC.presenter
//            let navigationController = AppliveryNavigationController(rootViewController: updateVC)
//            
//            self.waitForReadyThen {
//                self.presentModal(navigationController)
//            }
//        }
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
	
	func presentModal(_ viewController: UIViewController, animated: Bool) {
        viewController.modalPresentationStyle = .fullScreen
		let topVC = self.topViewController()
		topVC?.present(viewController, animated: animated, completion: nil)
	}
    
    func presentFeedbackForm() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.filter({ $0 is AppliveryWindow }).first {
            window.makeKeyAndVisible()
            if var topController = window.rootViewController {
                while let presentedController = topController.presentedViewController {
                    topController = presentedController
                }
                let vcToPresent = topController as? RecordingViewController
                vcToPresent?.presentActionSheet()
            }
        }
    }
	
	func showLoginView(message: String, cancelHandler: @escaping () -> Void, loginHandler: @escaping (_ user: String, _ password: String) -> Void) {
		var userText: UITextField?
		var passwordText: UITextField?
		self.alertLogin = UIAlertController(title: literal(.appName), message: message, preferredStyle: .alert)
		
		self.alertLogin.addTextField { textField in
			textField.placeholder = literal(.loginInputUser)
			userText = textField
		}
		self.alertLogin.addTextField { textField in
			textField.placeholder = literal(.loginInputPassword)
			textField.isSecureTextEntry = true
			passwordText = textField
		}
		
		let actionLogin = UIAlertAction(title: literal(.loginButton), style: .default) { _ in
			loginHandler(userText?.text ?? "", passwordText?.text ?? "")
		}
		 
		self.alertLogin.addAction(actionLogin)
		
		let topVC = self.topViewController()
		
		topVC?.present(self.alertLogin, animated: true, completion: nil)
	}
	
	func waitForReadyThen(_ onReady: @escaping () -> Void) {
		runInBackground {
			self.sleepUntilReady()
			runOnMainThreadAsync(onReady)
		}
	}
	
	
	// MARK: - Private Helpers
	
	private func sleepUntilReady() {
		while !self.rootViewIsReady() {
			sleep(for: 0.1)
		}
	}
	
	private func rootViewIsReady() -> Bool {
		var isReady = false
		// Wait until main thread complete check
		runOnMainThreadSynced {
			isReady = UIApplication.shared
				.keyWindow?
				.rootViewController?
				.isViewLoaded ?? false
		}
		return isReady
	}
	
	private func topViewController() -> UIViewController? {
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            
            if var topController = window.rootViewController {
                while let presentedController = topController.presentedViewController {
                    topController = presentedController
                }
                
                return topController
            }
        }
        
        return nil
	}
	
}
