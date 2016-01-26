//
//  DownloadServiceMock.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 7/1/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation
@testable import Applivery

class DownloadServiceMock: PDownloadService {
	
	// Inputs
	var inDownloadTokenResponse: DownloadTokenResponse!
	
	// Outputs
	var outFetchDownloadToken = (called: false, buildId: "")
	
	
	func fetchDownloadToken(buildId: String, completionHandler: (response: DownloadTokenResponse) -> Void) {
		self.outFetchDownloadToken = (true, buildId)
		completionHandler(response: self.inDownloadTokenResponse)
	}
	
}
