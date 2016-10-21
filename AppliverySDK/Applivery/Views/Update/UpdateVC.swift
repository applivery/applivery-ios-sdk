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
	@IBOutlet fileprivate weak var labelTitle: UILabel!
	@IBOutlet fileprivate weak var labelUpdateMessage: UILabel!
	@IBOutlet fileprivate weak var buttonUpdate: UIButton!
	@IBOutlet fileprivate weak var spiner: UIActivityIndicatorView!

	fileprivate let alert = UIAlertController(title: Localize("sdk_name"), message: nil, preferredStyle: .alert)


	// MARK - Factory method

	class func viewController() -> UpdateVC? {
		return UIStoryboard.initialViewController() as? UpdateVC
	}


	// MARK - View Lifecycle

	override func viewDidLoad() {
		self.setupView()
		self.presenter.viewDidLoad()
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}


	// MARK - UI Actions

	@IBAction func onButtonUpdateTap(_ sender: UIButton) {
		self.presenter.userDidTapDownload()
	}


	// MARK - Presenter

	func showUpdateMessage(_ message: String) {
		self.labelUpdateMessage.text = message
	}

	func showLoading() {
		self.spiner.startAnimating()
		self.spiner.isHidden = false
		self.buttonUpdate.isHidden = true
	}

	func stopLoading() {
		self.spiner.stopAnimating()
		self.spiner.isHidden = true
		self.buttonUpdate.isHidden = false
	}

	func showErrorMessage(_ message: String) {
		self.alert.message = message
		self.present(self.alert, animated: true, completion: nil)
	}


	// MARK - Private Helpers

	fileprivate func setupView() {
		self.labelTitle.text = Localize("sdk_name")

		self.buttonUpdate.setTitle(Localize("update_view_button_update"), for: UIControlState())
		self.buttonUpdate.layer.cornerRadius = 6

		self.alert.addAction(UIAlertAction(title: Localize("alert_button_ok"), style: UIAlertActionStyle.default, handler: nil))
	}

}
