//
//  AppliveryService.swift
//  AppliverySDK
//
//  Created by Abigail Dominguez Morlans on 23/9/25.
//  Copyright © 2025 Applivery S.L. All rights reserved.
//

import Foundation

/// Protocol for the AppliverySDK
/// - Since 4.5.0
/// - Version 4.5.0
@objc internal protocol AppliveryService: AnyObject {
    var logLevel: LogLevel { get set }
    var palette: Palette { get set }
    var textLiterals: TextLiterals { get set }

    func setLogHandler(_ handler: AppliveryLogHandler?)
    func start(token: String, tenant: String?, configuration: AppliveryConfiguration, skipUpdateCheck: Bool)
    func isUpToDate() -> Bool
    func update(onResult: ((UpdateResult) -> Void)?)
    func bindUser(email: String, firstName: String?, lastName: String?, tags: [String]?)
    func getUser(onSuccess: @escaping (NSDictionary?) -> Void)
    func unbindUser()
    func feedbackEvent()
    func handleRedirectURL(url: URL)
    func checkForUpdates(forceUpdate: Bool)
    func disableScreenshotFeedback()
    func enableScreenshotFeedback()
}
