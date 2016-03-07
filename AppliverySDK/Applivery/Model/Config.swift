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

	
	// MARK - Initializers
	
	convenience init(json: JSON) throws {
		self.init()
		
		guard
			let forceUpdate = json["sdk.ios.forceUpdate"]?.toBool(),
			let lastBuildId = json["sdk.ios.lastBuildId"]?.toString(),
			let otaUpdate	= json["sdk.ios.ota"]?.toBool()
			else { throw ConfigError.ParseJson }
		
		
		self.forceUpdate = forceUpdate
		self.otaUpdate = otaUpdate
		self.lastBuildId = lastBuildId
		self.otaUpdate = otaUpdate
		self.forceUpdateMessage = json["sdk.ios.mustUpdateMsg"]?.toString()
		self.otaUpdateMessage	= json["sdk.ios.updateMsg"]?.toString()
		self.minVersion = self.getParam("sdk.ios.minVersion", json: json, errorValue: "-1", shouldExists: self.forceUpdate)
		self.lastVersion = self.getParam("sdk.ios.lastBuildVersion", json: json, errorValue: "-1", shouldExists: self.otaUpdate)
	}
	
	
	// MARK - Private Helpers
	
	/// get an "optional" param that should exists
	private func getParam(parameter: String, json: JSON, errorValue: String, shouldExists: Bool) -> String {
		guard let param = json[parameter]?.toString() else {
			if shouldExists {
				LogWarn("Error parsing JSON: \(parameter) parameter not found")
			}
			
			return errorValue
		}
		
		return param
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
