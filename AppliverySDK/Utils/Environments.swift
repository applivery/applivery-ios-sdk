//
//  Environments.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 27/2/16.
//  Copyright © 2016 Applivery S.L. All rights reserved.
//

import Foundation

protocol EnvironmentProtocol {
    func getHost() -> String?
    func setHost(_ tenant: String?)
    func getHostDownload() -> String?
    func setHostDownload(_ tenant: String?)
}

final class Environments: EnvironmentProtocol {
    
    // MARK: - Keys
    private let hostKey: String = "APPLIVERY_HOST"
    private let hostDownloadKey: String = "APPLIVERY_HOST_DOWNLOAD"

    // MARK: - Properties
    private let userDefaults: UserDefaults
    private let processInfo: ProcessInfo

    // MARK: - Initializer
    init(
        userDefaults: UserDefaults = .standard,
        processInfo: ProcessInfo = .processInfo
    ) {
        self.userDefaults = userDefaults
        self.processInfo = processInfo
    }

    // MARK: - Public API
    func getHost() -> String? {
        return readValue(forKey: hostKey) ?? processInfo.environment[hostKey]
    }

    func setHost(_ tenant: String?) {
        guard let tenant = tenant else {
            writeValue("sdk-api.applivery.io", forKey: hostKey)
            return
        }
        writeValue("sdk-api.\(tenant).applivery.io", forKey: hostKey)
    }

    func getHostDownload() -> String? {
        return readValue(forKey: hostDownloadKey) ?? processInfo.environment[hostDownloadKey]
    }

    func setHostDownload(_ tenant: String?) {
        guard let tenant = tenant else {
            writeValue("download-api.applivery.io", forKey: hostDownloadKey)
            return
        }
        writeValue("download-api.\(tenant).applivery.io", forKey: hostDownloadKey)
    }

    // MARK: - Private Helpers
    private func readValue(forKey key: String) -> String? {
        return userDefaults.string(forKey: key)
    }

    private func writeValue(_ value: String, forKey key: String) {
        userDefaults.setValue(value, forKey: key)
    }
}
