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
    
    func setHost(_ tenant: String?) {
        if let tenant {
            let host = "sdk-api.\(tenant).applivery.io"
            values["APPLIVERY_HOST"] = host
        } else {
            let host = "sdk-api.applivery.io"
            values["APPLIVERY_HOST"] = host
        }
    }
    
    func getHostDownload() -> String? {
        return values["APPLIVERY_HOST_DOWNLOAD"]
    }
    
    func setHostDownload(_ tenant: String?) {
        if let tenant {
            let hostDownload = "download-api.\(tenant).applivery.io"
            values["APPLIVERY_HOST_DOWNLOAD"] = hostDownload
        } else {
            let hostDownload = "download-api.applivery.io"
            values["APPLIVERY_HOST_DOWNLOAD"] = hostDownload
        }
    }
    
}
