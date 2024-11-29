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
    func downloadURL(_ lastBuildId: String) async -> String?
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

    func downloadURL(_ lastBuildId: String) async -> String? {
        if let token = await service.fetchDownloadToken(with: lastBuildId) {
            let downloadURL = "itms-services://?action=download-manifest&url=https://\(self.globalConfig.hostDownload)/v1/download/\(token.data.token)/manifest.plist"
            return downloadURL
        } else {
            return nil
        }
    }

}
