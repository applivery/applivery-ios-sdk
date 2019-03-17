//
//  AppliveryNavigationController.swift
//  Applivery
//
//  Created by Alejandro Jiménez Agudo on 20/01/2019.
//  Copyright © 2019 Applivery S.L. All rights reserved.
//

import Foundation

class AppliveryNavigationController: UINavigationController {
	
	override func viewDidLoad() {
		let palette = GlobalConfig.shared.palette
		self.navigationBar.barTintColor = palette.primaryColor
		self.navigationBar.titleTextAttributes = [
			.foregroundColor: palette.primaryFontColor,
			.font: UIFont.systemFont(
				ofSize: 22,
				weight: .light
			)
		]
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
}
