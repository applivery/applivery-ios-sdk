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
	func downloadLastBuild()
	func isUpToDate() -> Bool
	func checkForceUpdate(_ config: Config?, version: String) -> Bool
	func checkOtaUpdate(_ config: Config?, version: String) -> Bool
}


struct UpdateInteractor: PUpdateInteractor {
	var output: UpdateInteractorOutput?
	
	let configData: PConfigDataManager
	let downloadData: PDownloadDataManager
	let app: AppProtocol
	let loginInteractor: LoginInteractor
	let globalConfig: GlobalConfig
	
	func forceUpdateMessage() -> String {
		let currentConfig = self.configData.getCurrentConfig()
		
		var message = literal(.forceUpdateMessage) ?? currentConfig.config?.forceUpdateMessage ?? kLocaleForceUpdateMessage
		
		if message == "" {
			message = kLocaleForceUpdateMessage
		}
		
		return message
	}
	
	func otaUpdateMessage() -> String {
		let currentConfig = self.configData.getCurrentConfig()
		var message = literal(.otaUpdateMessage) ?? currentConfig.config?.otaUpdateMessage ?? kLocaleOtaUpdateMessage
		
		if message == "" {
			message = kLocaleOtaUpdateMessage
		}
		
		return message
	}
	
	func downloadLastBuild() {
		guard let config = self.configData.getCurrentConfig().config else {
			self.output?.downloadDidFail(literal(.errorUnexpected) ?? localize("Current config is nil")); return
		}
		
		if config.forceAuth {
			self.loginInteractor.requestAuthorization(
				with: config,
				loginHandler: { self.download(with: config)},
				cancelHandler: {self.output?.downloadDidEnd()}
			)
		} else {
			self.download(with: config)
		}
	}
	
	func isUpToDate() -> Bool {
		let currentConfig = self.configData.getCurrentConfig()
		return !self.checkOtaUpdate(currentConfig.config, version: currentConfig.version)
	}
	
	func checkForceUpdate(_ config: Config?, version: String) -> Bool {
        guard
            let minVersion = config?.minVersion,
            let forceUpdate = config?.forceUpdate,
            forceUpdate
            else { return false }
        
        logInfo("Checking if app version: \(version) is older than minVersion: \(minVersion)")
        if self.isOlder(version, minVersion: minVersion) {
            return true
        }
        
        return false
    }
    
    func checkOtaUpdate(_ config: Config?, version: String) -> Bool {
        guard
            let lastVersion = config?.lastVersion,
            let otaUpdate = config?.otaUpdate,
            otaUpdate
            else { return false}
        
        logInfo("Checking if app version: \(version) is older than last build version: \(lastVersion)")
        if self.isOlder(version, minVersion: lastVersion) {
            return true
        }
		return false
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
	
	private func isOlder(_ currentVersion: String, minVersion: String) -> Bool {
        let (current, min) = self.equalLengthFillingWithZeros(left: currentVersion, right: minVersion)
        let result = current.compare(min, options: NSString.CompareOptions.numeric, range: nil, locale: nil)
        
        return result == ComparisonResult.orderedAscending
    }
    
    fileprivate func equalLengthFillingWithZeros(left: String, right: String) -> (String, String) {
        let componentsLeft = left.components(separatedBy: ".")
        let componentsRight = right.components(separatedBy: ".")
        
        if componentsLeft.count == componentsRight.count {
            return (left, right)
        } else if componentsLeft.count < componentsRight.count {
            let dif = componentsRight.count - componentsLeft.count
            let leftFilled = self.fillWithZeros(string: componentsLeft, length: dif)
            return (leftFilled, right)
        } else {
            let dif = componentsLeft.count - componentsRight.count
            let rightFilled = self.fillWithZeros(string: componentsRight, length: dif)
            return (left, rightFilled)
        }
    }
    
    fileprivate func fillWithZeros(string: [String], length: Int) -> String {
        var zeroFilledString = string
        for _ in 1...length {
            zeroFilledString.append("0")
        }
        
        return zeroFilledString.joined(separator: ".")
    }
}
