//
//  Storage.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 12/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation

class GlobalConfig {

	static var shared = GlobalConfig()

	// MARK: Global Constants
	static let SDKVersion             = App().getSDKVersion()
	static let Host                   = "https://" + (Environments.host() ?? "sdk-api.applivery.io")
	static let HostDownload           = "https://" + (Environments.hostDownload() ?? "download-api.applivery.io")
	static let ErrorDomain            = "com.applivery.network"
	static let AppliveryErrorKey      = "AppliveryMessage"
	static let AppliveryErrorDebugKey = "AppliveryDebugMessage"

	// MARK: Global Variables
	var appToken: String   = ""
	var appId: String      = ""
	var appStoreRelease    = false
	var feedbackEnabled    = true
	var logLevel: LogLevel = .info
	var palette            = Palette()
	var textLiterals       = TextLiterals()
	var accessToken: AccessToken?
}
