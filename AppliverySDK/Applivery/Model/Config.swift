//
//  Config.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 4/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import UIKit

enum ConfigError: ErrorType {
	case ParseJson
}

class Config {
	var minVersion: String!
	var forceUpdate = false
	var lastBuildId: String!
	var forceUpdateMessage: String?
	var otaUpdate = false
	var lastVersion: String!
	var otaUpdateMessage: String?

	
	convenience init(json: JSON) throws {
		self.init()
		
		guard
			let forceUpdate = json["sdk.ios.forceUpdate"]?.toBool(),
			let minVersion	= json["sdk.ios.minVersion"]?.toString(),
			let lastBuildId = json["sdk.ios.lastBuildId"]?.toString(),
			let otaUpdate	= json["sdk.ios.ota"]?.toBool(),
			let lastVersion	= json["sdk.ios.lastBuildVersion"]?.toString()
			else { throw ConfigError.ParseJson }
		
		self.forceUpdate = forceUpdate
		self.minVersion = minVersion
		self.lastBuildId = lastBuildId
		self.otaUpdate = otaUpdate
		self.lastVersion = lastVersion
		self.forceUpdateMessage = json["sdk.ios.mustUpdateMsg"]?.toString()
		self.otaUpdateMessage	= json["sdk.ios.updateMsg"]?.toString()
	}
}


func ==(a: Config, b: Config) -> Bool {
	var areEquals = true
	
	areEquals = areEquals && a.forceUpdate == b.forceUpdate
	areEquals = areEquals && a.minVersion == b.minVersion
	areEquals = areEquals && a.lastBuildId == b.lastBuildId
	areEquals = areEquals && a.forceUpdateMessage == b.forceUpdateMessage
	areEquals = areEquals && a.otaUpdate == b.otaUpdate
	areEquals = areEquals && a.otaUpdateMessage == b.otaUpdateMessage
	
	return areEquals
}
