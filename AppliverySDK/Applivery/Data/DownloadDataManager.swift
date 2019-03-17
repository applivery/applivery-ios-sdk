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
				let itmsService = "itms-services://?action=download-manifest&url="
				completionHandler(.success(url: "\(itmsService)\(GlobalConfig.Host)/download/\(lastBuildId)/manifest/\(token)"))

			case .error(let error):
				completionHandler(.error(message: error.message()))
			}
		}
	}

}
