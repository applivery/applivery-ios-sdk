//
//  Config.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 4/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import UIKit

struct Config: Codable {
    let status: Bool
    let data: ConfigData
}

struct ConfigData: Codable {
    let sdk: SDK
    let id: String
    let slug: String
    let oss: [String]
    let name: String
    let description: String
}

struct SDK: Codable {
    let ios: SDKData
}

struct SDKData: Codable {
    let minVersion: String?
    let forceUpdate: Bool
    let lastBuildId: String?
    let mustUpdateMsg: String?
    let ota: Bool
    let lastBuildVersion: String?
    let updateMsg: String?
    let forceAuth: Bool
    let lastBuildSize: Int? // Size in bytes
}
