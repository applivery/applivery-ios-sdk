//
//  DownloadService.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 7/1/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation

struct TokenData: Decodable {
    let token: String
}

struct DownloadToken: Decodable {
    let status: Bool
    let data: TokenData
}

protocol DownloadServiceProtocol {
    func fetchDownloadToken(with buildId: String) async -> DownloadToken?
}


class DownloadService: DownloadServiceProtocol {
	
    private let client: APIClientProtocol
    
    init(client: APIClientProtocol = APIClient()) {
        self.client = client
    }
    
    func fetchDownloadToken(with buildId: String) async -> DownloadToken? {
        do {
            logInfo("Requesting download token for build \(buildId).")
            let endpoint: AppliveryEndpoint = .download(buildId)
            let accessToken: DownloadToken = try await client.fetch(endpoint: endpoint)
            return accessToken
        } catch {
            logError(error as NSError)
            LoginManager().parse(
                error: error as NSError,
                retry: {
                    Task {
                        await self.fetchDownloadToken(with: buildId)
                    }
                },
                next: { }
            )
            return nil
        }
    }

//	func fetchDownloadToken(with buildId: String, completionHandler: @escaping (Result<String, NSError>) -> Void) {
//		self.request = Request(
//			endpoint: "/v1/build/\(buildId)/downloadToken")
//		self.request?.sendAsync { response in
//			if response.success {
//				guard let token = response.body?["token"]?.toString() else {
//					let error = NSError.unexpectedError(debugMessage: "Error trying to parse token", code: ErrorCodes.JsonParse)
//					completionHandler(.error(error))
//					return}
//				completionHandler(.success(token))
//			} else {
//				let error = response.error ?? NSError
//					.unexpectedError(debugMessage: "unexpected error while fetching download token")
//				logError(error)
//				LoginManager().parse(
//					error: error,
//					retry: { self.fetchDownloadToken(with: buildId, completionHandler: completionHandler) },
//					next: {	completionHandler(.error(error)) }
//				)
//			}
//		}
//	}

}
