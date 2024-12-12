//
//  FeedbackData.swift
//  Applivery
//
//  Created by Fran Alarza on 29/11/24.
//

import Foundation

struct FeedbackData: Encodable {
    let type: String
    let message: String
    let packageInfo: FeedbackPackageInfo
    let deviceInfo: DeviceInfo
    let screenshot: String?
    let hasVideo: Bool?
}

struct FeedbackPackageInfo: Encodable {
    let name: String
    let version: String
    let versionName: String
    
    init(app: AppProtocol) {
        name = app.bundleId()
        version = app.getVersion()
        versionName = app.getVersionName()
    }
}

struct DeviceInfo: Encodable {
    let device: DeviceData
    let os: OSInfo
    
    init(device: DeviceProtocol) {
        self.device = DeviceData(device: device)
        self.os = OSInfo(device: device)
    }
}

struct DeviceData: Encodable {
    let model: String
    let vendor: String
    let type: String
    let network: String
    let resolution: String
    let orientation: String
    let ramUsed: String
    let ramTotal: String
    let diskFree: String
    
    init(device: DeviceProtocol) {
        model = device.model()
        vendor = "Apple"
        type = device.type()
        network = device.networkType()
        resolution = device.resolution()
        orientation = device.orientation()
        ramUsed = device.ramUsed()
        ramTotal = device.ramTotal()
        diskFree = device.diskFree()
    }
}

struct OSInfo: Encodable {
    let name: String
    let version: String
    
    init(device: DeviceProtocol) {
        name = "ios"
        version = device.systemVersion()
    }
}
