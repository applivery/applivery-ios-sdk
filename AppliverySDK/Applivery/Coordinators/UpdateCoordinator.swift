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
	var app: AppProtocol
	var forceUpdateCalled = false
	
	// MARK: - Initializers
	init(updateInteractor: PUpdateInteractor, app: AppProtocol) {
		self.app = app
		self.updateInteractor = updateInteractor
		self.updateInteractor.output = self
	}
	
	init() {
		self.app = App()
		self.updateInteractor = Configurator.updateInteractor()
		self.updateInteractor.output = self
	}
	
	
	// MARK: - Public Methods
	func forceUpdate() {
//		guard !forceUpdateCalled else { return }
//		forceUpdateCalled = true
//        self.app.showForceUpdate()
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
	
	
	// MARK: - Update Interactor
	func downloadDidEnd() {
		self.app.hideLoading()
	}
	
	func downloadDidFail(_ message: String) {
		self.app.hideLoading()
		self.app.showErrorAlert(message) {
			self.downloadLastBuild()
		}
	}
	
	// MARK: - Private Helpers
	fileprivate func downloadLastBuild() {
		self.app.showLoading()
		self.updateInteractor.downloadLastBuild()
	}
}
