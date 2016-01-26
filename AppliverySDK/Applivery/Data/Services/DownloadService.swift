//
//  DownloadService.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 7/1/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation


enum DownloadTokenResponse {
	case Success(token: String)
	case Error(NSError)
}


protocol PDownloadService {
	func fetchDownloadToken(buildId: String, completionHandler: (response: DownloadTokenResponse) -> Void)
}


class DownloadService: PDownloadService {
	
	func fetchDownloadToken(buildId: String, completionHandler: (response: DownloadTokenResponse) -> Void) {
		let request = Request()
		request.endpoint = "/api/builds/\(buildId)/token"
		
		request.sendAsync { response in
			if response.success {
				guard let token = response.body?["token"]?.toString() else {
					completionHandler(response: .Error(self.parseError()))
					return
				}
				
				completionHandler(response: .Success(token: token))
			}
			else {
				let error = response.error ?? self.unexpectedError()
				LogError(error)
				completionHandler(response: .Error(error))
			}
		}
	}
	
	
	// MARK - Private Helpers
	
	private func parseError() -> NSError {
		let error = NSError (
			domain: GlobalConfig.ErrorDomain,
			code: 10001,
			userInfo: [GlobalConfig.AppliveryErrorDebugKey: "Error trying to parse token"])
		
		return error
	}
	
	private func unexpectedError() -> NSError {
		let error = NSError (
			domain: GlobalConfig.ErrorDomain,
			code: -1,
			userInfo: [GlobalConfig.AppliveryErrorDebugKey: "unexpected error while fetching download token"])
		
		return error
	}
	
}
