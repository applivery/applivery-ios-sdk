//
//  DownloadService.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 7/1/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation

protocol DownloadServiceProtocol {
    func fetchDownloadToken(with buildId: String) async -> DownloadToken?
    func downloadURL(_ lastBuildId: String) async -> String?
}

final class DownloadService: DownloadServiceProtocol {
	
    private let client: APIClientProtocol
    private var globalConfig: GlobalConfig
    
    init(
        client: APIClientProtocol = APIClient(),
        globalConfig: GlobalConfig = GlobalConfig.shared
    ) {
        self.client = client
        self.globalConfig = globalConfig
    }
    
    func fetchDownloadToken(with buildId: String) async -> DownloadToken? {
        do {
            logInfo("Requesting download token for build \(buildId).")
            let endpoint: AppliveryEndpoint = .download(buildId)
            let accessToken: DownloadToken = try await client.fetch(endpoint: endpoint)
            logInfo("Download token received.")
            return accessToken
        } catch {
            logError(error as NSError)
            return nil
        }
    }
    
    func downloadURL(_ lastBuildId: String) async -> String? {
        if let token = await fetchDownloadToken(with: lastBuildId) {
            let downloadURL = "itms-services://?action=download-manifest&url=https://\(self.globalConfig.hostDownload)/v1/download/\(token.data.token)/manifest.plist"
            return downloadURL
        } else {
            log("Token is nil.")
            return nil
        }
    }
}
