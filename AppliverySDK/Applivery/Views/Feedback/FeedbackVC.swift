//
//  FeedbackVC.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 28/2/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import UIKit


class FeedbackVC: UIViewController, FeedbackView {
	
	
	var presenter: FeedbackPresenter!
	
	
	// MARK - UI Properties
	
	@IBOutlet weak private var imageScreenshot: UIImageView!
	@IBOutlet weak private var feedbackForm: UIView!
	
	
	class func viewController() -> FeedbackVC {
		return UIStoryboard.viewController("FeedbackVC") as! FeedbackVC
	}
	
	
	// MARK - View Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.presenter.viewDidLoad()

		self.setupView()
	}
	
	
	// MARK - UI Actions
	
	@IBAction func onButtonCloseTap(sender: UIButton) {
		self.presenter.userDidTapCloseButton()
	}
	
	@IBAction func onButtonSendFeedback(sender: AnyObject) {
		self.presenter.userDidTapSendFeedbackButton()
	}
	
	
	// MARK - Presenter
	
	func showScreenshot(screenshot: UIImage) {
		self.imageScreenshot.image = screenshot
	}
	
	func showFeedbackFormulary() {
		self.imageScreenshot.hidden = true
		self.feedbackForm.hidden = false
	}
	
	
	// MARK - Private Helper
	
	private func setupView() {
		self.imageScreenshot.hidden = false
		self.feedbackForm.hidden = true
	}
	
	
	
}
