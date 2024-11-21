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
    private var globalConfig: GlobalConfig

    init(
        service: DownloadServiceProtocol = DownloadService(),
        globalConfig: GlobalConfig = GlobalConfig()
    ) {
		self.service = service
        self.globalConfig = globalConfig
	}


	func downloadUrl(_ lastBuildId: String, completionHandler: @escaping (_ response: DownloadUrlResponse) -> Void) {
		self.service.fetchDownloadToken(with: lastBuildId) { response in
			switch response {

			case .success(let token):
                let downloadURL = "itms-services://?action=download-manifest&url=\(self.globalConfig.hostDownload)/v1/download/\(token)/manifest.plist"
				completionHandler(.success(url: downloadURL))

			case .error(let error):
				completionHandler(.error(message: error.message()))
			}
		}
	}

}
