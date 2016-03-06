//
//  FeedbackVC.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 28/2/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import UIKit


class FeedbackVC: UIViewController, FeedbackView, UITextViewDelegate {
	
	
	var presenter: FeedbackPresenter!
	
	
	// MARK - UI Properties
	
	@IBOutlet weak private var imageScreenshot: UIImageView!
	@IBOutlet weak private var feedbackForm: UIView!
	@IBOutlet weak private var imageScreenshotPreview: UIImageView!
	@IBOutlet weak private var textViewMessage: UITextView!
	private var isMessagePlaceholderShown = true
	
	// MARK - UI Constraints
	@IBOutlet weak var bottomFeedbackFormConstraint: NSLayoutConstraint!
	@IBOutlet weak var widthScreenshotConstraint: NSLayoutConstraint!
	private var widthScreenshotConstant: CGFloat!
	
	
	class func viewController() -> FeedbackVC {
		return UIStoryboard.viewController("FeedbackVC") as! FeedbackVC
	}
	
	
	// MARK - View Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.presenter.viewDidLoad()
		
		self.setupView()
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	
	// MARK - UI Actions
	
	@IBAction func onButtonCloseTap(sender: UIButton) {
		self.presenter.userDidTapCloseButton()
	}
	
	@IBAction func onButtonSendFeedback(sender: AnyObject) {
		self.presenter.userDidTapSendFeedbackButton()
	}
	
	@IBAction func onAttachSwitchChanged(sender: UISwitch) {
		self.presenter.userDidChangedAttachScreenshot(sender.on)
	}
	
	// MARK - TextView
	
	func textViewDidBeginEditing(textView: UITextView) {
		if self.isMessagePlaceholderShown {
			self.textViewMessage.text = nil
			self.isMessagePlaceholderShown = false
		}
	}
	
	
	// MARK - Presenter
	
	func showScreenshot(screenshot: UIImage) {
		self.imageScreenshot.image = screenshot
		self.imageScreenshotPreview.image = screenshot
	}
	
	func showFeedbackFormulary() {
		self.imageScreenshot.hidden = true
		self.feedbackForm.hidden = false
	}
	
	func showScreenshotPreview() {
		self.widthScreenshotConstraint.constant = 0
		
		UIView.animateWithDuration(0.4) {
			self.imageScreenshotPreview.alpha = 1
			self.view.layoutIfNeeded()
		}
	}
	
	func hideScreenshotPreview() {
		self.widthScreenshotConstraint.constant = -self.imageScreenshotPreview.frame.size.width
		
		UIView.animateWithDuration(0.4) {
			self.imageScreenshotPreview.alpha = 0
			self.view.layoutIfNeeded()
		}
	}
	
	
	// MARK - Private Helper
	
	private func setupView() {
		self.imageScreenshot.hidden = false
		self.feedbackForm.hidden = true
		self.manageKeyboardEvent()
	}
	
	private func manageKeyboardEvent() {
		Keyboard.keyboardWillShow { notification in
			guard let size = Keyboard.keyboardSize(notification) else {
				LogWarn("Couldn't get keyboard size")
				return
			}
			
			self.bottomFeedbackFormConstraint.constant = size.height
			self.animateKeyboardChanges(notification)
		}
	}
	
	private func animateKeyboardChanges(notification: NSNotification) {
		let duration = Keyboard.keyboardAnimationDuration(notification)
		let curve = Keyboard.keyboardAnimationCurve(notification)
		
		UIView.animateWithDuration(duration,
			delay: 0,
			options: curve,
			animations: {
				self.view.layoutIfNeeded()
			},
			completion: nil
		)
	}
	
}
