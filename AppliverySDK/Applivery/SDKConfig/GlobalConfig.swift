//
//  Storage.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 12/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation

class GlobalConfig {
	
	static let shared = GlobalConfig()
	
	// MARK: Global Constants
	static let Host = Environments.Host() ?? "https://dashboard.applivery.com"
	static let ErrorDomain = "com.applivery.network"
	static let AppliveryErrorKey = "AppliveryMessage"
	static let AppliveryErrorDebugKey = "AppliveryDebugMessage"
	
	
	// MARK: Global Variables
	var apiKey: String!
	var appId: String!
	var appStoreRelease = false
	var feedbackEnabled = true
	var logLevel: LogLevel = .None
	
	
	// MARK: Static texts
	static let DefaultForceUpdateMessage = "Sorry this App is outdated. Please, update the App to continue using it"
	static let DefaultOtaUpdateMessage = "There is a new version available for download. Do you want to update to the latest version?"
	
}
