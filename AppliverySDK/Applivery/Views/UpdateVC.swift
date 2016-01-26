//
//  UpdateVC.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 21/11/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import UIKit


class UpdateVC: UIViewController, UpdateView {
	
	var presenter: UpdatePresenter!
	
	// UI Properties
	@IBOutlet private weak var labelTitle: UILabel!
	@IBOutlet private weak var labelUpdateMessage: UILabel!
	@IBOutlet private weak var buttonUpdate: UIButton!
	@IBOutlet private weak var spiner: UIActivityIndicatorView!
	
	private let alert = UIAlertController(title: Localize("sdk_name"), message: nil, preferredStyle: .Alert)
	
	
	// MARK - Factory method
	
	class func viewController() -> UpdateVC {
		let storyboard = UIStoryboard(name: "Applivery", bundle: NSBundle.AppliveryBundle())
		let vc = storyboard.instantiateInitialViewController() as! UpdateVC
		
		return vc
	}
	
	
	// MARK - View Lifecycle
	
	override func viewDidLoad() {
		self.setupView()
		self.presenter.viewDidLoad()
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	
	// MARK - UI Actions
	
	@IBAction func onButtonUpdateTap(sender: UIButton) {
		self.presenter.userDidTapDownload()
	}
	
	
	// MARK - Presenter
	
	func showUpdateMessage(message: String) {
		self.labelUpdateMessage.text = message
	}
	
	func showLoading() {
		self.spiner.startAnimating()
		self.spiner.hidden = false
		self.buttonUpdate.hidden = true
	}
	
	func stopLoading() {
		self.spiner.stopAnimating()
		self.spiner.hidden = true
		self.buttonUpdate.hidden = false
	}
	
	func showErrorMessage(message: String) {
		self.alert.message = message
		self.presentViewController(self.alert, animated: true, completion: nil)
	}
	
	
	// MARK - Private Helpers
	
	private func setupView() {
		self.labelTitle.text = Localize("sdk_name")
		
		self.buttonUpdate.setTitle(Localize("update_view_button_update"), forState: .Normal)
		self.buttonUpdate.layer.cornerRadius = 6
		
		self.alert.addAction(UIAlertAction(title: Localize("alert_button_ok"), style: UIAlertActionStyle.Default, handler: nil))
	}
	
}
