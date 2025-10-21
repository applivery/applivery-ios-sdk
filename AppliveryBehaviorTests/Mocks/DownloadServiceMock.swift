//
//  DownloadServiceMock.swift
//  AppliverySDK
//
//  Created by Abigail Dominguez Morlans on 30/9/25.
//  Copyright © 2025 Applivery S.L. All rights reserved.
//

@testable import Applivery

class DownloadServiceMock: DownloadServiceProtocol {
    var stubbedToken: DownloadToken?
    var stubbedURL: String?
    var fetchDownloadTokenCalled = false
    var downloadURLCalled = false

    func fetchDownloadToken(with buildId: String) async -> DownloadToken? {
        fetchDownloadTokenCalled = true
        return stubbedToken
    }

    func downloadURL(_ lastBuildId: String) async -> String? {
        downloadURLCalled = true
        return stubbedURL
    }
}
