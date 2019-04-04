//
//  DownloadDataManager.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 7/1/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


enum DownloadUrlResponse {
	case success(url: String)
	case error(message: String)
}


protocol PDownloadDataManager {
	func downloadUrl(_ lastBuildId: String, completionHandler: @escaping (_ response: DownloadUrlResponse) -> Void)
}


class DownloadDataManager: PDownloadDataManager {

	fileprivate var service: DownloadServiceProtocol

	init(service: DownloadServiceProtocol = DownloadService()) {
		self.service = service
	}


	func downloadUrl(_ lastBuildId: String, completionHandler: @escaping (_ response: DownloadUrlResponse) -> Void) {
		self.service.fetchDownloadToken(with: lastBuildId) { response in
			switch response {

			case .success(let token):
				let downloadURL = "itms-services://?action=download-manifest&url=\(GlobalConfig.HostDownload)/v1/download/\(token)/manifest.plist"
				completionHandler(.success(url: downloadURL))

			case .error(let error):
				completionHandler(.error(message: error.message()))
			}
		}
	}

}
