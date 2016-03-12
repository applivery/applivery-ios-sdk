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
	func downloadDidFail(message: String)
}


protocol PUpdateInteractor {
	var output: UpdateInteractorOutput! { get set }
	
	func forceUpdateMessage() -> String
	func otaUpdateMessage() -> String
	func downloadLastBuild()
}


class UpdateInteractor: PUpdateInteractor {
	
	var output: UpdateInteractorOutput!
	
	private var configData: PConfigDataManager
	private var downloadData: PDownloadDataManager
	private var app: PApp
	
	
	init(configData: PConfigDataManager = ConfigDataManager(), downloadData: PDownloadDataManager = DownloadDataManager(), app: PApp = App()) {
		self.configData = configData
		self.downloadData = downloadData
		self.app = app
	}
	
	
	func forceUpdateMessage() -> String {
		let (currentConfig, _) = self.configData.getCurrentConfig()
		
		var message = currentConfig?.forceUpdateMessage ?? GlobalConfig.DefaultForceUpdateMessage
		
		if message == "" {
			message = GlobalConfig.DefaultForceUpdateMessage
		}
		
		return message
	}
	
	func otaUpdateMessage() -> String {
		let (currentConfig, _) = self.configData.getCurrentConfig()
		var message = currentConfig?.otaUpdateMessage ?? GlobalConfig.DefaultOtaUpdateMessage
		
		if message == "" {
			message = GlobalConfig.DefaultOtaUpdateMessage
		}
		
		return message
	}
	
	func downloadLastBuild() {
		guard let lastBuildId = self.configData.getCurrentConfig().config?.lastBuildId else {
			self.output.downloadDidFail(Localize("error_unexpected"))
			return
		}
		
		self.downloadData.downloadUrl(lastBuildId) { response in
			switch response {

			case .Success(let url):
				if self.app.openUrl(url) {
					self.output.downloadDidEnd()
				}
				else {
					let error = NSError.AppliveryError(Localize("error_download_url"))
					LogError(error)
					
					self.output.downloadDidFail(error.message())
				}

			case .Error(let message):
				self.output.downloadDidFail(message)
			}
		}
	}
}