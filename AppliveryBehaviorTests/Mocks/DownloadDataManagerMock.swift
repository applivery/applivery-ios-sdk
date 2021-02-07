//
//  DownloadDataManagerMock.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 7/1/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation
@testable import Applivery


class DownloadDataManagerMock: PDownloadDataManager {

	// Inputs
	var inDownloadResponse: DownloadUrlResponse!

	// Outputs
	var outDownloadUrl = (called: false, lastBuildId: "")

	func downloadUrl(_ lastBuildId: String, completionHandler: @escaping (_ response: DownloadUrlResponse) -> Void) {
		self.outDownloadUrl = (true, lastBuildId)
		completionHandler(self.inDownloadResponse)
	}

}
