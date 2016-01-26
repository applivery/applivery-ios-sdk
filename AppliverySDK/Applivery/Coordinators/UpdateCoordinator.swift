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
	
	private lazy var updateVC = UpdateVC.viewController()
	private var updateInteractor: PUpdateInteractor
	private var app: PApp
	private var forceUpdateCalled = false
	
	
	// MARK - Initializers
	init(updateInteractor: PUpdateInteractor = UpdateInteractor(), app: PApp = App()) {
		self.updateInteractor = updateInteractor
		self.app = app
	}
	
	
	// MARK - Public Methods
	
	func forceUpdate() {
		guard !forceUpdateCalled else { return }
		forceUpdateCalled = true
		
		self.updateVC.presenter = UpdatePresenter()
		self.updateVC.presenter.view = self.updateVC
		self.updateVC.presenter.updateInteractor = UpdateInteractor()
		self.updateVC.presenter.updateInteractor.output = self.updateVC.presenter
		
		self.app.waitForReadyThen {
			self.app.presentModal(self.updateVC)
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
	
	func downloadDidFail(message: String) {
		self.app.hideLoading()
		self.app.showErrorAlert(message) {
			self.downloadLastBuild()
		}
	}
	
	
	// MARK - Private Helpers
	
	private func downloadLastBuild() {
		self.app.showLoading()
		self.updateInteractor.downloadLastBuild()
	}
}
