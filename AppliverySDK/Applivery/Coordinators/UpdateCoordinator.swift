//
//  UpdateCoordinator.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 21/11/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation


protocol PUpdateCoordinator {

	func forceUpdate()
	func otaUpdate()

}


class UpdateCoordinator: PUpdateCoordinator, UpdateInteractorOutput {
	var updateInteractor: PUpdateInteractor
	fileprivate var app: AppProtocol
	fileprivate var forceUpdateCalled = false


	// MARK - Initializers
	init(updateInteractor: PUpdateInteractor = UpdateInteractor(), app: AppProtocol = App()) {
		self.updateInteractor = updateInteractor
		self.app = app
	}


	// MARK - Public Methods

	func forceUpdate() {
		guard !forceUpdateCalled else { return }
		forceUpdateCalled = true

		if let updateVC = UpdateVC.viewController() {
			updateVC.presenter = UpdatePresenter(
				updateInteractor: UpdateInteractor(),
				view: updateVC
			)
			updateVC.presenter.updateInteractor.output = updateVC.presenter

			self.app.waitForReadyThen {
				self.app.presentModal(updateVC)
			}
		}
	}

	func otaUpdate() {
		self.updateInteractor.output = self
		let message = self.updateInteractor.otaUpdateMessage()

		self.app.waitForReadyThen {
			self.app.showOtaAlert(message) {
				self.downloadLastBuild()
			}
		}
	}


	// MARK - Update Interactor

	func downloadDidEnd() {
		self.app.hideLoading()
	}

	func downloadDidFail(_ message: String) {
		self.app.hideLoading()
		self.app.showErrorAlert(message) {
			self.downloadLastBuild()
		}
	}


	// MARK - Private Helpers

	fileprivate func downloadLastBuild() {
		self.app.showLoading()
		self.updateInteractor.downloadLastBuild()
	}
}
