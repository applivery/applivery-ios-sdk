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
    func setHost(_ host: String?)
    func getHostDownload() -> String?
    func setHostDownload(_ hostDownload: String?)
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

    func setHost(_ host: String?) {
        guard let host = host else { return }
        writeValue(host, forKey: hostKey)
    }

    func getHostDownload() -> String? {
        return readValue(forKey: hostDownloadKey) ?? processInfo.environment[hostDownloadKey]
    }

    func setHostDownload(_ hostDownload: String?) {
        guard let hostDownload = hostDownload else { return }
        writeValue(hostDownload, forKey: hostDownloadKey)
    }

    // MARK: - Private Helpers
    private func readValue(forKey key: String) -> String? {
        return userDefaults.string(forKey: key)
    }

    private func writeValue(_ value: String, forKey key: String) {
        userDefaults.setValue(value, forKey: key)
    }
}
