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
	@IBOutlet private weak var labelUpdateMessage: UILabel!
	@IBOutlet private weak var buttonUpdate: UIButton!
	@IBOutlet private weak var spiner: UIActivityIndicatorView!
	

	private let alert = UIAlertController(title: literal(.appName), message: nil, preferredStyle: .alert)


	// MARK: - Factory method

	class func viewController() -> UpdateVC? {
		return UIStoryboard.initialViewController() as? UpdateVC
	}


	// MARK: - View Lifecycle

	override func viewDidLoad() {
		self.setupView()
		self.presenter.viewDidLoad()
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}


	// MARK: - UI Actions

	@IBAction func onButtonUpdateTap(_ sender: UIButton) {
		self.presenter.userDidTapDownload()
	}


	// MARK: - Presenter

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


	// MARK: - Private Helpers

	private func setupView() {
		self.setColors()
		self.title = literal(.appName)

		self.buttonUpdate.setTitle(literal(.buttonForceUpdate), for: UIControl.State())
		self.buttonUpdate.layer.cornerRadius = 6

		self.alert.addAction(UIAlertAction(
			title: literal(.alertButtonOK),
			style: .default,
			handler: nil
		))
	}
	
	private func setColors() {
		let palette = GlobalConfig.shared.palette
		self.view.backgroundColor = palette.secondaryColor
		self.labelUpdateMessage.textColor = palette.secondaryFontColor
	}

}
