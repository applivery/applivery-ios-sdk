//
//  DownloadService.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 7/1/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


protocol DownloadServiceProtocol {
	func fetchDownloadToken(with buildId: String, completionHandler: @escaping (Result<String, NSError>) -> Void)
}


class DownloadService: DownloadServiceProtocol {
	
	var request: Request?

	func fetchDownloadToken(with buildId: String, completionHandler: @escaping (Result<String, NSError>) -> Void) {
		self.request = Request(
			endpoint: "/api/builds/\(buildId)/token"
		)

		self.request?.sendAsync { response in
			if response.success {
				guard let token = response.body?["token"]?.toString() else {
					let error = NSError.unexpectedError(debugMessage: "Error trying to parse token", code: ErrorCodes.JsonParse)
					completionHandler(.error(error))
					return
				}
				completionHandler(.success(token))
			} else {
				let error = response.error ?? NSError
					.unexpectedError(debugMessage: "unexpected error while fetching download token")
				logError(error)
				completionHandler(.error(error))
			}
		}
	}

}
