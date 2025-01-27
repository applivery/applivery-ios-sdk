//
//  AppInfo.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 5/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

// Wrapper for Application's operation

protocol AppProtocol {
	func bundleId() -> String
	func getSDKVersion() -> String
	func getBuildNumber() -> String
	func getVersion() -> String
	func getLanguage() -> String
	func openUrl(_ url: String) -> Bool
	func showOtaAlert(_ message: String, downloadHandler: @escaping () -> Void)
    func showForceUpdate()
    func showErrorAlert(_ message: String)
    func showLoginAlert(downloadHandler: @escaping () -> Void)
	func waitForReadyThen(_ onReady: @escaping () -> Void)
	func presentModal(_ viewController: UIViewController, animated: Bool)
    func presentFeedbackForm()
    func topViewController() -> UIViewController?
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
	
	func getBuildNumber() -> String {
		guard let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
			return "NO_VERSION_FOUND"
		}
		return version
	}
	
	func getVersion() -> String {
		guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
			return "NO_VERSION_FOUND"
		}
		return version
	}
	
	func getSDKVersion() -> String {
        AppliverySDK.sdkVersion
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
	

	
	func showAlert(_ message: String) {
		let alert = UIAlertController(title: literal(.appName), message: message, preferredStyle: .alert)
		
		let actionLater = UIAlertAction(title: literal(.alertButtonOK), style: .cancel, handler: nil)
		alert.addAction(actionLater)
		
		let topVC = self.topViewController()
		
		topVC?.present(alert, animated: true, completion: nil)
	}
    
    func showLoginAlert(downloadHandler: @escaping () -> Void) {
        self.alertOta = UIAlertController(title: literal(.appName), message: literal(.loginMessage), preferredStyle: .alert)
        
        let aceptAction = UIAlertAction(title: literal(.loginButton), style: .default) { _ in
            downloadHandler()
        }
        
        self.alertOta.addAction(aceptAction)
        
        let topVC = self.topViewController()
        
        topVC?.present(self.alertOta, animated: true, completion: nil)
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
        let viewController = UIHostingController(rootView: ForceUpdateScreen())
        let navigationController = AppliveryNavigationController(rootViewController: viewController)
        
        self.waitForReadyThen {
            self.presentModal(navigationController)
        }
    }
	
	func showErrorAlert(_ message: String) {
		self.alertError = UIAlertController(title: literal(.appName), message: message, preferredStyle: .alert)
		
        let actionCancel = UIAlertAction(title: literal(.alertButtonCancel), style: .default, handler: nil)
				
        alertError.addAction(actionCancel)
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
	
    func topViewController() -> UIViewController? {
        guard
            let keyWindow = UIApplication.shared
                .connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow }),
            let rootVC = keyWindow.rootViewController
        else {
            return nil
        }
        
        return findTopViewController(from: rootVC)
    }

    private func findTopViewController(from root: UIViewController) -> UIViewController {
        if let presentedVC = root.presentedViewController {
            logInfo("Top VC find presented VC")
            return findTopViewController(from: presentedVC)
        }
        
        if let navController = root as? UINavigationController,
           let visibleVC = navController.visibleViewController {
            logInfo("Top VC find nav VC")
            return findTopViewController(from: visibleVC)
        }
        
        if let tabController = root as? UITabBarController,
           let selectedVC = tabController.selectedViewController {
            logInfo("Top VC find tab VC")
            return findTopViewController(from: selectedVC)
        }
        
        return root
    }
}
