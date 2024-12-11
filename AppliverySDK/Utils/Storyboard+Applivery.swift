//
//  Storyboard+Applivery.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 28/2/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {

	class func initialViewController() -> UIViewController {
		let storyboard = UIStoryboard.storyBoard()
		guard let viewController = storyboard.instantiateInitialViewController() else {
			logWarn("Couldn't initialize view controller")
			return UIViewController()
		}

		return viewController
	}

	class func viewController(_ identifier: String) -> UIViewController {
		let storyboard = UIStoryboard.storyBoard()
		let viewController = storyboard.instantiateViewController(withIdentifier: identifier)

		return viewController
	}


	fileprivate class func storyBoard() -> UIStoryboard {
		return UIStoryboard(name: "Applivery", bundle: Bundle.applivery())
	}

}
