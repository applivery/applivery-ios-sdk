//
//  Storyboard+Applivery.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 28/2/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation

extension UIStoryboard {

	class func initialViewController() -> UIViewController {
		let storyboard = UIStoryboard.storyBoard()
		let vc = storyboard.instantiateInitialViewController()

		return vc!
	}

	class func viewController(_ identifier: String) -> UIViewController {
		let storyboard = UIStoryboard.storyBoard()
		let vc = storyboard.instantiateViewController(withIdentifier: identifier)

		return vc
	}


	fileprivate class func storyBoard() -> UIStoryboard {
		return UIStoryboard(name: "Applivery", bundle: Bundle.AppliveryBundle())
	}

}
