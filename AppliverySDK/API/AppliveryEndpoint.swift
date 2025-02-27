//
//  AppliveryEndpoint.swift
//  Applivery
//
//  Created by Fran Alarza on 27/11/24.
//

import Foundation


enum AppliveryEndpoint {
    case config
    case login(LoginData)
    case bind(User)
    case download(String)
    case feedback(FeedbackData)
    case redirect
}

extension AppliveryEndpoint: Endpoint {

    var host: String {
        switch self {
        case .config: return GlobalConfig().host
        case .login: return GlobalConfig().host
        case .bind: return GlobalConfig().host
        case .download: return GlobalConfig().host
        case .feedback: return GlobalConfig().host
        case .redirect: return GlobalConfig().host
        }
    }
    
    var headers: [String : String]? {
        let appToken = "Bearer \(GlobalConfig.shared.appToken)"
        let app = GlobalConfig.shared.app
        let device = GlobalConfig.shared.device
        let version = app.getSDKVersion()

        var headers: [String: String] = [
            "Content-Type": "application/json",
            "Accept-Language": app.getLanguage(),
            "Authorization": appToken,
            "x-installation-token": device.vendorId(),
            "x-sdk-version": "IOS_\(version)",
            "x-app-version": app.getVersion(),
            "x-os-version": device.systemVersion(),
            "x-os-name": device.systemName(),
            "x-device-vendor": "Apple",
            "x-device-model": device.model(),
            "x-device-type": device.type(),
            "x-package-name": app.bundleId(),
            "x-package-version": app.getBuildNumber()
        ]

        if let authToken = GlobalConfig.shared.accessToken?.token {
            headers["x-sdk-auth-token"] = authToken
        } else {
            logInfo("Token is empty")
        }
        
        return headers
    }
    
    var path: String {
        switch self {
        case .config:
            return "/v1/app"
        case .login:
            return "/v1/auth/login"
        case .bind:
            return "/v1/auth/customLogin"
        case .download(let buildId):
            return "/v1/build/\(buildId)/downloadToken"
        case .feedback:
            return "/v1/feedback"
        case .redirect:
            return "/v1/auth/redirect"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .config, .download, .redirect:
            return .get
        case .login, .bind, .feedback:
            return .post
        }
    }
    
    var body: [String : Any]? {
        switch self {
        case .config, .download, .redirect:
            return nil
        case .login(let loginData):
            return loginData.dictionary
        case .bind(let user):
            return user.dictionary
        case .feedback(let feedback):
            return feedback.dictionary
        }
    }
}

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization
            .jsonObject(with: data, options: .allowFragments))
            .flatMap { $0 as? [String: Any] }
    }
}
