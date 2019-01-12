//
//  FeedbackVC.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 28/2/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//
import UIKit


class FeedbackVC: UIViewController {
	var presenter: FeedbackPresenter!
	
	fileprivate var previewVC: PreviewVC?
	fileprivate var isMessagePlaceholderShown = true
	
	// MARK: - Constants
	fileprivate static let BugTypeIndex = 0
	fileprivate static let FeedbackTypeIndex = 1
	
	// MARK: - UI Properties
	@IBOutlet weak fileprivate var navigationBar: UIView!
	@IBOutlet weak fileprivate var buttonClose: UIButton!
	@IBOutlet weak fileprivate var labelApplivery: UILabel!
	@IBOutlet weak fileprivate var buttonAddFeedback: UIButton!
	@IBOutlet weak fileprivate var buttonSendFeedback: UIButton!
	@IBOutlet weak fileprivate var screenshotContainer: UIView!
	@IBOutlet weak fileprivate var screenshotBackground: UIView!
	@IBOutlet weak fileprivate var labelFeedbackType: UILabel!
	@IBOutlet weak fileprivate var segmentedControlType: UISegmentedControl!
	@IBOutlet weak fileprivate var feedbackForm: UIView!
	@IBOutlet weak fileprivate var imageScreenshotPreview: UIImageView!
	@IBOutlet weak fileprivate var textViewMessage: UITextView!
	@IBOutlet weak fileprivate var labelAttach: UILabel!
	@IBOutlet weak fileprivate var switchAttach: UISwitch!
	
	// MARK: - UI Constraints
	@IBOutlet weak var bottomFeedbackFormConstraint: NSLayoutConstraint!
	@IBOutlet weak var widthScreenshotConstraint: NSLayoutConstraint!
	private var widthScreenshotConstant: CGFloat!
	
	
	class func viewController() -> FeedbackVC {
		let feedbackVC = UIStoryboard.viewController("FeedbackVC") as? FeedbackVC
		return feedbackVC ?? FeedbackVC()
	}
	
}

// MARK: - View Lifecycle
extension FeedbackVC {
	
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
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let previewVC = segue.destination as? PreviewVC else {
			return logWarn("Expected PreviewVC")
		}
		
		self.previewVC = previewVC
	}
	
}


// MARK: - UI Actions
extension FeedbackVC {
	
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
			self.presenter.userDidSelectedFeedbackType(.bug)
			
		case FeedbackVC.FeedbackTypeIndex:
			self.presenter.userDidSelectedFeedbackType(.feedback)
			
		default: logWarn("Selected segment index out of bounds")
		}
	}
	
	@IBAction func onPreviewTap(_ sender: Any) {
		self.presenter.userDidTapPreview()
	}
	
	override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
		if motion == .motionShake {
			self.presenter.userDidShake()
		}
	}
	
}


// MARK: - TextView
extension FeedbackVC: UITextViewDelegate {

	func textViewDidBeginEditing(_ textView: UITextView) {
		if self.isMessagePlaceholderShown {
			self.textViewMessage.text = nil
			self.isMessagePlaceholderShown = false
		}
	}
	
}


// MARK: - FeedbackView
extension FeedbackVC: FeedbackView {
	
	/// If nil, will reuse the current screenshot
	func showScreenshot(_ screenshot: UIImage?) {
		self.buttonAddFeedback.isHidden = false
		self.buttonSendFeedback.isHidden = true
		
		if let screenshot = screenshot {
			self.previewVC?.screenshot = screenshot
			self.startScreenshotAnimated()
			
		} else {
			Keyboard.didHide { _ in
				self.showScreenshotAnimated()
			}
			
			self.view.endEditing(true)
		}
	}
	
	private func startScreenshotAnimated() {
		let screenshotCopy = UIImageView(image: self.previewVC?.editedScreenshot)
		screenshotCopy.frame = self.view.frame
		screenshotCopy.contentMode = .scaleAspectFit
		self.view.addSubview(screenshotCopy)
		self.feedbackForm.alpha = 0
		
		DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(700)) {
			UIView.animate(
				withDuration: 0.4,
				delay: 0,
				usingSpringWithDamping: 0.5,
				initialSpringVelocity: 0.4,
				options: .curveLinear,
				animations: {
					screenshotCopy.frame = self.screenshotContainer.frame
			},
				completion: { _ in
					screenshotCopy.removeFromSuperview()
			})
		}
	}
	
	private func showScreenshotAnimated() {
		let screenshotCopy = UIImageView(image: self.previewVC?.editedScreenshot)
		let frame = CGRect(
			origin: self.view.convert(CGPoint.zero, from: self.imageScreenshotPreview),
			size: self.imageScreenshotPreview.frame.size
		)
		screenshotCopy.frame = frame
		screenshotCopy.contentMode = .scaleAspectFit
		self.view.addSubview(screenshotCopy)
		self.imageScreenshotPreview.isHidden = true
		self.screenshotContainer.isHidden = true
		
		UIView.animate(
			withDuration: 0.4,
			delay: 0,
			usingSpringWithDamping: 0.6,
			initialSpringVelocity: 0.2,
			options: .curveLinear,
			animations: {
				screenshotCopy.frame = self.screenshotContainer.frame
				self.screenshotContainer.alpha = 1
				self.feedbackForm.alpha = 0
		},
			completion: { _ in
				self.screenshotContainer.isHidden = false
				screenshotCopy.removeFromSuperview()
		})
	}
	
	func restoreSceenshot(_ screenshot: UIImage) {
		self.previewVC?.screenshot = screenshot
	}
	
	func showFeedbackFormulary(with preview: UIImage) {
		self.imageScreenshotPreview.image = preview
		
		self.buttonAddFeedback.isHidden = true
		self.buttonSendFeedback.isHidden = false
		
		let screenshotCopy = UIImageView(image: self.previewVC?.editedScreenshot)
		screenshotCopy.frame = self.screenshotContainer.frame
		screenshotCopy.contentMode = .scaleAspectFit
		self.view.addSubview(screenshotCopy)
		self.imageScreenshotPreview.isHidden = true
		self.screenshotContainer.isHidden = true
		
		UIView.animate(
			withDuration: 0.4,
			delay: 0,
			usingSpringWithDamping: 0.7,
			initialSpringVelocity: 0.2,
			options: .curveLinear,
			animations: {
				self.screenshotContainer.alpha = 0
				self.feedbackForm.alpha = 1
				let frame = CGRect(
					origin: self.view.convert(CGPoint.zero, from: self.imageScreenshotPreview),
					size: self.imageScreenshotPreview.frame.size
				)
				screenshotCopy.frame = frame
		},
			completion: { _ in
				self.imageScreenshotPreview.isHidden = false
				screenshotCopy.removeFromSuperview()
				self.textViewMessage.becomeFirstResponder()
		})
	}
	
	func showScreenshotPreview() {
		self.widthScreenshotConstraint.constant = 0
		
		UIView.animate(withDuration: 0.4) {
			self.imageScreenshotPreview.alpha = 1
			self.view.layoutIfNeeded()
		}
	}
	
	func hideScreenshotPreview() {
		self.widthScreenshotConstraint.constant = -self.imageScreenshotPreview.frame.size.width
		
		UIView.animate(withDuration: 0.4) {
			self.imageScreenshotPreview.alpha = 0
			self.view.layoutIfNeeded()
		}
	}
	
	func textMessage() -> String? {
		guard !self.isMessagePlaceholderShown && self.textViewMessage.text.count > 0 else {
			return nil
		}
		
		return self.textViewMessage.text
	}
	
	func needMessage() {
		self.textViewMessage.becomeFirstResponder()
	}
	
	func showMessage(_ message: String) {
		let alert = UIAlertController(
			title: literal(.appName),
			message: message,
			preferredStyle: .alert
		)
		
		alert.addAction(
			UIAlertAction(
				title: literal(.alertButtonOK),
				style: .cancel,
				handler: { _ in runOnMainThreadAsync(self.stopLoading) }
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
	
	func editedScreenshot() -> UIImage? {
		return self.previewVC?.editedScreenshot
	}
	
}


// MARK: - Private Helpers
extension FeedbackVC {
	
	fileprivate func setupView() {
		self.setColors()
		self.buttonSendFeedback.isHidden = true
		self.buttonAddFeedback.isHidden = false
		self.screenshotContainer.isHidden = false
		self.feedbackForm.isHidden = false
		
		self.localizeView()
		self.manageKeyboardShowEvent()
		self.manageKeyboardHideEvent()
		
		self.screenshotContainer.translatesAutoresizingMaskIntoConstraints = false
		self.screenshotContainer.addConstraint(NSLayoutConstraint(
			item: self.screenshotContainer,
			attribute: NSLayoutAttribute.width,
			relatedBy: NSLayoutRelation.equal,
			toItem: self.screenshotContainer,
			attribute: NSLayoutAttribute.height,
			multiplier: UIScreen.main.bounds.width / UIScreen.main.bounds.height,
			constant: 0
		))
	}
	
	private func setColors() {
		let palette = GlobalConfig.shared.palette
		self.view.backgroundColor = palette.primaryColor
		self.screenshotBackground.backgroundColor = palette.secondaryColor
		self.navigationBar.backgroundColor = palette.primaryColor
		self.buttonClose.setTitleColor(palette.primaryFontColor, for: .normal)
		self.labelApplivery.textColor = palette.primaryFontColor
		self.buttonAddFeedback.setTitleColor(palette.primaryFontColor, for: .normal)
		self.buttonSendFeedback.setTitleColor(palette.primaryFontColor, for: .normal)
		self.feedbackForm.backgroundColor = palette.secondaryColor
		self.labelFeedbackType.textColor = palette.secondaryFontColor
		self.segmentedControlType.tintColor = palette.primaryColor
		self.labelAttach.textColor = palette.secondaryFontColor
		self.switchAttach.onTintColor = palette.primaryColor
		self.textViewMessage.tintColor = palette.primaryColor
		self.textViewMessage.layer.borderColor = palette.primaryColor.cgColor
		self.textViewMessage.layer.borderWidth = 1
		self.textViewMessage.layer.cornerRadius = 5
	}
	
	private func localizeView() {
		self.buttonClose.setTitle(literal(.feedbackButtonClose), for: UIControlState())
		self.labelApplivery.text = literal(.appName)
		self.buttonAddFeedback.setTitle(literal(.feedbackButtonAdd), for: UIControlState())
		self.buttonSendFeedback.setTitle(literal(.feedbackButtonSend), for: UIControlState())
		self.labelFeedbackType.text = literal(.feedbackSelectType)
		self.segmentedControlType.setTitle(literal(.feedbackTypeBug), forSegmentAt: FeedbackVC.BugTypeIndex)
		self.segmentedControlType.setTitle(literal(.feedbackTypeFeedback), forSegmentAt: FeedbackVC.FeedbackTypeIndex)
		self.textViewMessage.text = literal(.feedbackMessagePlaceholder)
		self.labelAttach.text = literal(.feedbackAttach)
	}
	
	private func manageKeyboardShowEvent() {
		Keyboard.willShow { notification in
			guard let size = Keyboard.size(notification) else {
				logWarn("Couldn't get keyboard size")
				return
			}
			
			self.bottomFeedbackFormConstraint.constant = size.height
			self.animateKeyboardChanges(notification as Notification)
		}
	}
	
	private func manageKeyboardHideEvent() {
		Keyboard.willHide { notification in
			self.bottomFeedbackFormConstraint.constant = 0
			self.animateKeyboardChanges(notification as Notification)
		}
	}
	
	private func animateKeyboardChanges(_ notification: Notification) {
		let duration = Keyboard.animationDuration(notification)
		let curve = Keyboard.animationCurve(notification)
		
		UIView.animate(
			withDuration: duration,
			delay: 0,
			options: curve,
			animations: {
				self.view.layoutIfNeeded()
		})
	}
	
}
