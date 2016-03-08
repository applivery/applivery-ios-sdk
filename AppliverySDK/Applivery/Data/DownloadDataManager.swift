//
//  DownloadDataManager.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 7/1/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


enum DownloadUrlResponse {
	case Success(url: String)
	case Error(message: String)
}


protocol PDownloadDataManager {
	func downloadUrl(lastBuildId: String, completionHandler: (response: DownloadUrlResponse) -> Void)
}


class DownloadDataManager: PDownloadDataManager {
	
	private var service: PDownloadService
	
	init(service: PDownloadService = DownloadService()) {
		self.service = service
	}
	
	
	func downloadUrl(lastBuildId: String, completionHandler: (response: DownloadUrlResponse) -> Void) {
		self.service.fetchDownloadToken(lastBuildId) { response in
			switch response {
				
			case .Success(let token):
				let itms_service = "itms-services://?action=download-manifest&url="
				completionHandler(response: .Success(url: "\(itms_service)\(GlobalConfig.Host)/download/\(lastBuildId)/manifest/\(token)"))
				
			case .Error(let error):
				completionHandler(response: .Error(message: error.message()))
			}
		}
	}
	
}