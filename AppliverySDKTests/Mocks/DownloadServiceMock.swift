//
//  DownloadServiceMock.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 7/1/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation
@testable import Applivery

class DownloadServiceMock: DownloadServiceProtocol {

	// Inputs
	var inDownloadTokenResponse: Result<String, NSError>!

	// Outputs
	var outFetchDownloadToken = (called: false, buildId: "")


	func fetchDownloadToken(with buildId: String, completionHandler: @escaping (_ response: Result<String, NSError>) -> Void) {
		self.outFetchDownloadToken = (true, buildId)
		completionHandler(self.inDownloadTokenResponse)
	}

}
