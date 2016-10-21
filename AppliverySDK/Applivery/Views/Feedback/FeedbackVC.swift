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

	fileprivate var isMessagePlaceholderShown = true

	// MARK - Constants
	fileprivate static let BugTypeIndex = 0
	fileprivate static let FeedbackTypeIndex = 1

	// MARK - UI Properties
	@IBOutlet weak fileprivate var buttonClose: UIButton!
	@IBOutlet weak fileprivate var labelApplivery: UILabel!
	@IBOutlet weak fileprivate var buttonAddFeedback: UIButton!
	@IBOutlet weak fileprivate var buttonSendFeedback: UIButton!
	@IBOutlet weak fileprivate var imageScreenshot: UIImageView!
	@IBOutlet weak fileprivate var labelFeedbackType: UILabel!
	@IBOutlet weak fileprivate var segmentedControlType: UISegmentedControl!
	@IBOutlet weak fileprivate var feedbackForm: UIView!
	@IBOutlet weak fileprivate var imageScreenshotPreview: UIImageView!
	@IBOutlet weak fileprivate var textViewMessage: UITextView!
	@IBOutlet weak fileprivate var labelAttach: UILabel!

	// MARK - UI Constraints
	@IBOutlet weak var bottomFeedbackFormConstraint: NSLayoutConstraint!
	@IBOutlet weak var widthScreenshotConstraint: NSLayoutConstraint!
	fileprivate var widthScreenshotConstant: CGFloat!


	class func viewController() -> FeedbackVC? {
		return UIStoryboard.viewController("FeedbackVC") as? FeedbackVC
	}


	// MARK - View Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		self.presenter.viewDidLoad()

		self.setupView()
	}

	override func viewWillDisappear(_ animated: Bool) {
		App().hideLoading()

		super.viewWillDisappear(animated)
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}


	// MARK - UI Actions

	@IBAction func onButtonCloseTap(_ sender: UIButton) {
		self.presenter.userDidTapCloseButton()
	}

	@IBAction func onButtonAddFeedback(_ sender: AnyObject) {
		self.presenter.userDidTapAddFeedbackButton()
	}

	@IBAction func onAttachSwitchChanged(_ sender: UISwitch) {
		self.presenter.userDidChangedAttachScreenshot(attach: sender.isOn)
	}

	@IBAction func onButtonSendFeedbackTap(_ sender: AnyObject) {
		self.presenter.userDidTapSendFeedbackButton()
	}

	@IBAction func onSegmentedControlChanged(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case FeedbackVC.BugTypeIndex:
			self.presenter.userDidSelectedFeedbackType(.Bug)

		case FeedbackVC.FeedbackTypeIndex:
			self.presenter.userDidSelectedFeedbackType(.Feedback)

		default:
			LogWarn("Selected segment index out of bounds")
		}
	}


	// MARK - TextView

	func textViewDidBeginEditing(_ textView: UITextView) {
		if self.isMessagePlaceholderShown {
			self.textViewMessage.text = nil
			self.isMessagePlaceholderShown = false
		}
	}


	// MARK - Presenter

	func showScreenshot(_ screenshot: UIImage) {
		self.imageScreenshot.image = screenshot
		self.imageScreenshotPreview.image = screenshot
	}

	func showFeedbackFormulary() {
		self.imageScreenshot.isHidden = true
		self.feedbackForm.isHidden = false
		self.buttonAddFeedback.isHidden = true
		self.buttonSendFeedback.isHidden = false
		self.textViewMessage.becomeFirstResponder()
	}

	func showScreenshotPreview() {
		self.widthScreenshotConstraint.constant = 0

		UIView.animate(withDuration: 0.4, animations: {
			self.imageScreenshotPreview.alpha = 1
			self.view.layoutIfNeeded()
		})
	}

	func hideScreenshotPreview() {
		self.widthScreenshotConstraint.constant = -self.imageScreenshotPreview.frame.size.width

		UIView.animate(withDuration: 0.4, animations: {
			self.imageScreenshotPreview.alpha = 0
			self.view.layoutIfNeeded()
		})
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

	func showMessage(_ message: String) {
		let alert = UIAlertController(
			title: Localize("sdk_name"),
			message: message,
			preferredStyle: .alert
		)

		alert.addAction(
			UIAlertAction(
				title: Localize("alert_button_ok"),
				style: .cancel,
				handler: { _ in runOnMainThread(self.stopLoading) }
			)
		)

		self.present(alert, animated: true, completion: nil)
	}

	func showLoading() {
		self.buttonSendFeedback.isEnabled = false
		self.buttonSendFeedback.alpha = 0.5
		self.feedbackForm.isUserInteractionEnabled = false
		self.feedbackForm.alpha = 0.5
		App().showLoading()
	}

	func stopLoading() {
		self.buttonSendFeedback.isEnabled = true
		self.buttonSendFeedback.alpha = 1
		self.feedbackForm.isUserInteractionEnabled = true
		self.feedbackForm.alpha = 1
		App().hideLoading()
	}


	// MARK - Private Helper

	fileprivate func setupView() {
		self.buttonSendFeedback.isHidden = true
		self.buttonAddFeedback.isHidden = false
		self.imageScreenshot.isHidden = false
		self.feedbackForm.isHidden = true

		self.localizeView()
		self.manageKeyboardShowEvent()
		self.manageKeyboardHideEvent()
	}

	fileprivate func localizeView() {
		self.buttonClose.setTitle(Localize("feedback_button_close"), for: UIControlState())
		self.labelApplivery.text = Localize("sdk_name")
		self.buttonAddFeedback.setTitle(Localize("feedback_button_add"), for: UIControlState())
		self.buttonSendFeedback.setTitle(Localize("feedback_button_send"), for: UIControlState())
		self.labelFeedbackType.text = Localize("feedback_label_select_type")
		self.segmentedControlType.setTitle(Localize("feedback_button_bug"), forSegmentAt: FeedbackVC.BugTypeIndex)
		self.segmentedControlType.setTitle(Localize("feedback_button_feedback"), forSegmentAt: FeedbackVC.FeedbackTypeIndex)
		self.textViewMessage.text = Localize("feedback_text_message_placeholder")
		self.labelAttach.text = Localize("feedback_label_attach")
	}

	fileprivate func manageKeyboardShowEvent() {
		Keyboard.willShow { notification in
			guard let size = Keyboard.size(notification) else {
				LogWarn("Couldn't get keyboard size")
				return
			}

			self.bottomFeedbackFormConstraint.constant = size.height
			self.animateKeyboardChanges(notification as Notification)
		}
	}

	fileprivate func manageKeyboardHideEvent() {
		Keyboard.willHide { notification in
			self.bottomFeedbackFormConstraint.constant = 0
			self.animateKeyboardChanges(notification as Notification)
		}
	}

	fileprivate func animateKeyboardChanges(_ notification: Notification) {
		let duration = Keyboard.animationDuration(notification)
		let curve = Keyboard.animationCurve(notification)

		UIView.animate(withDuration: duration,
			delay: 0,
			options: curve,
			animations: {
				self.view.layoutIfNeeded()
			},
			completion: nil
		)
	}

}
