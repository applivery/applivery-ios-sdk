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
    
    private let environments: EnvironmentProtocol
    
    init(environments: EnvironmentProtocol = Environments()) {
        self.environments = environments
    }
	
    var host: String {
        return (environments.getHost() ?? "sdk-api.applivery.io")
    }

    var hostDownload: String {
        return (environments.getHostDownload() ?? "download-api.applivery.io")
    }
    
	// MARK: Global Constants
	static let ErrorDomain            = "com.applivery.network"
	static let AppliveryErrorKey      = "AppliveryMessage"
	static let AppliveryErrorDebugKey = "AppliveryDebugMessage"

	// MARK: Global Variables
	var appToken: String       = ""
	var appId: String          = ""
	var feedbackEnabled        = true
	var logLevel: LogLevel     = .info
	var palette                = Palette()
	var textLiterals           = TextLiterals()
	var app: AppProtocol 	   = App()
	var device: DeviceProtocol = Device()
    var logHandler: AppliveryLogHandler?
    var accessToken: AccessToken?
    var configuration: AppliveryConfiguration?
    var isCheckForUpdatesBackgroundEnabled = false
    var isForegroundObserverAdded = false
}
