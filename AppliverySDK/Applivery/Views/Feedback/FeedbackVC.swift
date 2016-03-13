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
	
	private var isMessagePlaceholderShown = true
	
	// MARK - UI Properties
	@IBOutlet weak private var buttonClose: UIButton!
	@IBOutlet weak private var labelApplivery: UILabel!
	@IBOutlet weak private var buttonAddFeedback: UIButton!
	@IBOutlet weak private var buttonSendFeedback: UIButton!
	@IBOutlet weak private var imageScreenshot: UIImageView!
	@IBOutlet weak private var labelFeedbackType: UILabel!
	@IBOutlet weak private var buttonBug: ButtonFeedbackType!
	@IBOutlet weak private var buttonFeedback: ButtonFeedbackType!
	@IBOutlet weak private var feedbackForm: UIView!
	@IBOutlet weak private var imageScreenshotPreview: UIImageView!
	@IBOutlet weak private var textViewMessage: UITextView!
	@IBOutlet weak private var labelAttach: UILabel!
	
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
	
	@IBAction func onButtonAddFeedback(sender: AnyObject) {
		self.presenter.userDidTapAddFeedbackButton()
	}
	
	@IBAction func onButtonSendFeedbackTap(sender: AnyObject) {
		self.presenter.userDidTapSendFeedbackButton()
	}
	
	@IBAction func onAttachSwitchChanged(sender: UISwitch) {
		self.presenter.userDidChangedAttachScreenshot(sender.on)
	}
	
	@IBAction func onButtonFeedbackTap(sender: ButtonFeedbackType) {
		sender.selected = true
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
		self.buttonAddFeedback.hidden = true
		self.buttonSendFeedback.hidden = false
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
	
	func textMessage() -> String? {
		guard
			!self.isMessagePlaceholderShown &&
				self.textViewMessage.text.characters.count > 0
			else {
				return nil
		}
		
		return self.textViewMessage.text
	}
	
	func needMessage() {
		self.textViewMessage.becomeFirstResponder()
	}
	
	func showMessage(message: String) {
		let alert = UIAlertController(
			title: Localize("sdk_name"),
			message: message,
			preferredStyle: .Alert
		)
		
		alert.addAction(
			UIAlertAction(
				title: Localize("alert_button_ok"),
				style: .Cancel,
				handler: nil
			)
		)
		
		self.presentViewController(alert, animated: true, completion: nil)
	}
	
	
	// MARK - Private Helper
	
	private func setupView() {
		self.buttonSendFeedback.hidden = true
		self.buttonAddFeedback.hidden = false
		self.imageScreenshot.hidden = false
		self.feedbackForm.hidden = true
		self.buttonBug.exclusive = self.buttonFeedback
		self.buttonBug.selected = true
		
		self.localizeView()
		self.manageKeyboardEvent()
	}
	
	private func localizeView() {
		self.buttonClose.setTitle(Localize("feedback_button_close"), forState: .Normal)
		self.labelApplivery.text = Localize("sdk_name")
		self.buttonAddFeedback.setTitle(Localize("feedback_button_add"), forState: .Normal)
		self.buttonSendFeedback.setTitle(Localize("feedback_button_send"), forState: .Normal)
		self.labelFeedbackType.text = Localize("feedback_label_select_type")
		self.buttonBug.setTitle(Localize("feedback_button_bug"), forState: .Normal)
		self.buttonFeedback.setTitle(Localize("feedback_button_feedback"), forState: .Normal)
		self.textViewMessage.text = Localize("feedback_text_message_placeholder")
		self.labelAttach.text = Localize("feedback_label_attach")
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
