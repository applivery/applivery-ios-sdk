//
//  Config.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 4/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import UIKit

enum ConfigError: Error {
	case parseJson
}

class Config: Equatable {
	var minVersion: String?
	var forceUpdate = false
	var lastBuildId: String?
	var forceUpdateMessage: String?
	var otaUpdate = false
	var lastVersion: String?
	var otaUpdateMessage: String?
	var forceAuth = false


	// MARK: - Initializers

	convenience init(json: JSON) throws {
		self.init()

		guard
			let forceUpdate = json["sdk.ios.forceUpdate"]?.toBool(),
			let otaUpdate	= json["sdk.ios.ota"]?.toBool()
			else { throw ConfigError.parseJson }


		self.forceUpdate = forceUpdate
		self.otaUpdate = otaUpdate
		self.otaUpdate = otaUpdate
		self.forceUpdateMessage = json["sdk.ios.mustUpdateMsg"]?.toString()
		self.otaUpdateMessage	= json["sdk.ios.updateMsg"]?.toString()
		self.forceAuth = json["sdk.ios.forceAuth"]?.toBool() ?? false
		self.minVersion = self.getParam("sdk.ios.minVersion", json: json, shouldExists: self.forceUpdate)
		self.lastVersion = self.getParam("sdk.ios.lastBuildVersion", json: json, shouldExists: self.otaUpdate)
		self.lastBuildId = self.getParam("sdk.ios.lastBuildId", json: json, shouldExists: self.otaUpdate)
	}


	// MARK: - Private Helpers

	/// get an "optional" param that should exists
	fileprivate func getParam(_ parameter: String, json: JSON, shouldExists: Bool) -> String {
		guard let param = json[parameter]?.toString() else {
			if shouldExists {
				logWarn("Error parsing JSON: \(parameter) parameter not found")
			}

			return "-1"
		}

		return param
	}
}


func == (left: Config, right: Config) -> Bool {
	var areEquals = true

	areEquals = areEquals && left.forceUpdate == right.forceUpdate
	areEquals = areEquals && left.minVersion == right.minVersion
	areEquals = areEquals && left.lastBuildId == right.lastBuildId
	areEquals = areEquals && left.forceUpdateMessage == right.forceUpdateMessage
	areEquals = areEquals && left.otaUpdate == right.otaUpdate
	areEquals = areEquals && left.otaUpdateMessage == right.otaUpdateMessage
	areEquals = areEquals && left.forceAuth == right.forceAuth

	return areEquals
}
