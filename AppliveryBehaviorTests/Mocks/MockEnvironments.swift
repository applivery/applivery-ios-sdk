//
//  MockEnvironments.swift
//  Applivery
//
//  Created by Fran Alarza on 21/11/24.
//

@testable import Applivery

final class MockEnvironments: EnvironmentProtocol {

    private var values: [String: String] = [:]

    func getHost() -> String? {
        return values["APPLIVERY_HOST"]
    }

    func setHost(_ host: String?) {
        values["APPLIVERY_HOST"] = host
    }

    func getHostDownload() -> String? {
        return values["APPLIVERY_HOST_DOWNLOAD"]
    }

    func setHostDownload(_ hostDownload: String?) {
        values["APPLIVERY_HOST_DOWNLOAD"] = hostDownload
    }
}
