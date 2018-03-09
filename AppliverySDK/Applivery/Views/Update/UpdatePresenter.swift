//
//  UpdatePresenter.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 21/11/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation


protocol UpdateView {
	func showUpdateMessage(_ message: String)
	func showLoading()
	func stopLoading()
	func showErrorMessage(_ message: String)
}

struct UpdatePresenter: UpdateInteractorOutput {

	var updateInteractor: PUpdateInteractor
	var view: UpdateView

	func viewDidLoad() {
		let updateMessage = self.updateInteractor.forceUpdateMessage()
		self.view.showUpdateMessage(updateMessage)
	}

	func userDidTapDownload() {
		self.view.showLoading()
		self.updateInteractor.download()
	}


	// MARK: - Update Interactor Output

	func downloadDidEnd() {
		self.view.stopLoading()
	}

	func downloadDidFail(_ message: String) {
		self.view.stopLoading()
		self.view.showErrorMessage(message)
	}

}
