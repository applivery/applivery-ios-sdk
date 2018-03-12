//
//  UpdateInteractor.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 21/11/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation


protocol UpdateInteractorOutput {
	func downloadDidEnd()
	func downloadDidFail(_ message: String)
}

protocol PUpdateInteractor {
	var output: UpdateInteractorOutput? { get set }
	
	func forceUpdateMessage() -> String
	func otaUpdateMessage() -> String
	func downloadLasBuild()
}


class UpdateInteractor: PUpdateInteractor {
	
	var output: UpdateInteractorOutput?
	
	private var configData: PConfigDataManager
	private var downloadData: PDownloadDataManager
	private var app: AppProtocol
	private var loginInteractor: LoginInteractor
	private var globalConfig: GlobalConfig
	
	
	init(configData: PConfigDataManager = ConfigDataManager(), downloadData: PDownloadDataManager = DownloadDataManager(), app: AppProtocol = App(), globalConfig: GlobalConfig = GlobalConfig.shared) {
		self.configData = configData
		self.downloadData = downloadData
		self.app = app
		self.globalConfig = globalConfig
		self.loginInteractor = LoginInteractor(app: self.app, loginService: LoginService(), globalConfig: self.globalConfig)
	}
	
	func forceUpdateMessage() -> String {
		let (currentConfig, _) = self.configData.getCurrentConfig()
		
		var message = literal(.forceUpdateMessage) ?? currentConfig?.forceUpdateMessage ?? localize("force_update_message")
		
		if message == "" {
			message = localize("force_update_message")
		}
		
		return message
	}
	
	func otaUpdateMessage() -> String {
		let (currentConfig, _) = self.configData.getCurrentConfig()
		var message = literal(.otaUpdateMessage) ?? currentConfig?.otaUpdateMessage ?? localize("ota_update_message")
		
		if message == "" {
			message = localize("ota_update_message")
		}
		
		return message
	}
	
	func downloadLasBuild() {
		guard let config = self.configData.getCurrentConfig().config else {
			self.output?.downloadDidFail(literal(.errorUnexpected) ?? localize("Current config is nil")); return
		}
		
		if config.authUpdate {
			self.loginInteractor.requestAuthorization(
				with: config,
				loginHandler: { self.download(with: config)},
				cancelHandler: {self.output?.downloadDidEnd()}
			)
		} else {
			self.download(with: config)
		}
	}
	
	// MARK: - Private Helpers
	
	private func download(with config: Config) {
		guard let lastBuildId = config.lastBuildId else {
			self.output?.downloadDidFail(literal(.errorUnexpected) ?? localize("Last build id not found")); return
		}
		
		self.downloadData.downloadUrl(lastBuildId) { response in
			switch response {
				
			case .success(let url):
				if self.app.openUrl(url) {
					self.output?.downloadDidEnd()
				} else {
					let error = NSError.appliveryError(literal(.errorDownloadURL))
					logError(error)
					
					self.output?.downloadDidFail(error.message())
				}
				
			case .error(let message):
				self.output?.downloadDidFail(message)
			}
		}
	}
}
