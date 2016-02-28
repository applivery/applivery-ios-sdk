//
//  FeedbackVC.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 28/2/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import UIKit


class FeedbackVC: UIViewController, FeedbackView {
	
	class func viewController() -> FeedbackVC {
		return UIStoryboard.viewController("FeedbackVC") as! FeedbackVC
	}
	
	var presenter: FeedbackPresenter!
	
	
	@IBAction func onButtonCloseTap(sender: UIButton) {
		self.presenter.userDidTapCloseButton()
	}
	
}
