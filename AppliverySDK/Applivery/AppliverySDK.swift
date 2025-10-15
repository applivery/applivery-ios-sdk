//
//  AppliverySDK.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 3/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation
import UIKit

/// Type of Applivery's logs you want displayed in the debug console
@objc public enum LogLevel: Int {
    /// No log will be shown. Recommended for production environments.
    case none = 0

    /// Only warnings and errors. Recommended for develop environments.
    case error = 1

    /// Errors and relevant information. Recommended for test integrating Applivery.
    case info = 2

    /// Request and Responses to Applivery's server will be displayed. Not recommended to use, only for debugging Applivery.
    case debug = 3
}

/// Represents the possible result types of an update operation.
///
/// This enumeration is compatible with Objective-C and defines the possible states of an update,
/// whether it was successful or encountered an error.
@objc public enum UpdateResultType: Int {

    /// Indicates that the update operation completed successfully.
    case success

    /// Indicates that the update operation failed due to an error.
    case error
}

/// Defines specific error codes that can occur during an update operation.
///
/// This enumeration is compatible with Objective-C and provides a list of detailed errors that
/// describe potential failures during the update process.
@objc public enum UpdateError: Int {

    /// No error; used to represent a state without errors.
    case noError = 0

    /// Indicates that the necessary configuration was not found to proceed with the update.
    case noConfigFound = 1001

    /// Indicates that authentication is required to complete the update.
    case authRequired = 1002

    /// Indicates that there was an error downloading the update manifest.
    case downloadManifestError = 1003

    /// Indicates that the required download URL for the update was not found.
    case downloadUrlNotFound = 1004

    /// Indicates that the app is up to date.
    case isUpToDate = 1005

}

/// Represents the result of an update operation, indicating whether it was successful or if an error occurred.
///
/// This class is compatible with Objective-C and encapsulates both the result type and any associated
/// error that may have occurred during the update operation.
@objc public class UpdateResult: NSObject {
    @objc public let type: UpdateResultType
    @objc public let error: UpdateError

    @objc private init(type: UpdateResultType, error: UpdateError) {
        self.type = type
        self.error = error
    }

    @objc public static func success() -> UpdateResult {
        return UpdateResult(type: .success, error: .noError)
    }

    @objc public static func failure(error: UpdateError) -> UpdateResult {
        return UpdateResult(type: .error, error: error)
    }
}

public typealias AppliveryLogHandler = @convention(block) (
    NSString,         // message
    Int,              // level
    NSString,         // filename
    Int,              // line
    NSString          // function
) -> Void

/**
 The Applivery's class provides the entry point to the Applivery service.

 ### Usage

 You should use the `shared` property to get a unique singleton instance, then set your `logLevel` configuration and finally call to the method:

 start(appToken appToken: String, appId: String, appStoreRelease: Bool)


 ### Overview

 When Applivery's starts, the latests configuration for your build will be retrieved, and the build version of your app will be checked. Then applivery could:
 1. Do nothing if the app is in the latest version or any update is checked in the app configuration.
 2. Shows a cancellable alert if there is a new available update in Applivery, giving the user the chance to update to the latest build.
 3. Shows a modal screen, that user can not dismiss, with the only option to update to the latest build. This will force yours users to update giving them any chance to continue using the app.

 - SeeAlso: [Applivery's README on GitHub](https://github.com/applivery/applivery-ios-sdk/blob/master/README.md)
 - Since: 1.0
 - Version: 4.5.0
 - Author: Alejandro Jiménez Agudo
 - Copyright: Applivery S.L.
 */
public class AppliverySDK: NSObject, AppliveryService {
    // MARK: Static Properties
    internal static let sdkVersion = "4.5.2"

    // MARK: Type Properties
    /// Singleton instance
    @objc public static let shared = AppliverySDK()
    var window: AppliveryWindow?

    // MARK: Instance Properties
    @objc public var logLevel: LogLevel { didSet {
        self.globalConfig.logLevel = self.logLevel
    }}

    /// Allows the client to provide a custom log callback, so they can
    /// integrate Applivery logs into their own logging system.
    @objc public func setLogHandler(_ handler: AppliveryLogHandler?) {
        self.globalConfig.logHandler = handler
    }

    @objc public var palette: Palette { didSet {
        self.globalConfig.palette = self.palette
    }}

    @objc public var textLiterals: TextLiterals { didSet {
        self.globalConfig.textLiterals = self.textLiterals
    }}

    private var host: String? {
        get { environments.getHost() }
        set { environments.setHost(newValue) }
    }

    private var hostDownload: String? {
        get { environments.getHostDownload() }
        set { environments.setHostDownload(newValue) }
    }

    // MARK: Private properties
    private let startInteractor: StartInteractor
    private let updateService: UpdateServiceProtocol
    private let globalConfig: GlobalConfig
    private let loginService: LoginServiceProtocol
    private let app: AppProtocol
    private let environments: EnvironmentProtocol

    // MARK: Initializers
    override convenience init() {
        self.init(
            startInteractor: StartInteractor(),
            globalConfig: GlobalConfig.shared,
            updateService: UpdateService(eventDetector: BackgroundDetector()),
            loginService: LoginService(),
            app: App(),
            environments: Environments()
        )
    }

    internal init (startInteractor: StartInteractor,
                   globalConfig: GlobalConfig,
                   updateService: UpdateServiceProtocol,
                   loginService: LoginServiceProtocol,
                   app: AppProtocol,
                   environments: EnvironmentProtocol) {
        self.startInteractor = startInteractor
        self.globalConfig = globalConfig
        self.updateService = updateService
        self.loginService = loginService
        self.app = app
        self.environments = environments
        self.logLevel = .info
        self.palette = Palette()
        self.textLiterals = TextLiterals()
        self.globalConfig.palette = self.palette
        self.globalConfig.textLiterals = self.textLiterals
    }

    // MARK: - Instance Methods
    @objc public func start(
        token: String,
        tenant: String? = nil,
        configuration: AppliveryConfiguration = .empty,
        skipUpdateCheck: Bool = true
    ) {
        self.globalConfig.appToken = token
        host = tenant
        hostDownload = tenant
        self.globalConfig.configuration = configuration
        self.startInteractor.start(skipUpdateCheck: skipUpdateCheck)
    }

    @objc public func isUpToDate() -> Bool {
        var upToDate: Bool?
        let semaphore = DispatchSemaphore(value: 0)
        Task {
            do {
                upToDate = try await updateService.isUpToDate()
            } catch {
                logInfo("Checking if the app is up to date failed")
                upToDate = true
            }
            semaphore.signal()
        }
        semaphore.wait()
        return upToDate ?? true
    }

    @objc public func update(onDownload: ((UpdateResult) -> Void)? = nil) {
        self.updateService.downloadLastBuild(onResult: onDownload)
    }

    @objc public func bindUser(email: String, firstName: String? = nil, lastName: String? = nil, tags: [String]? = nil, onComplete: (() -> Void)? = nil) {
        let compactedTags = tags?.compactMap(removeEmpty) // Example: ["", "aaa", ""] -> ["aaa"]
        let user = User(
            email: email,
            firstName: firstName,
            lastName: lastName,
            tags: compactedTags
        )
        user.log()
        Task {
            try await loginService.bind(user: user)
            onComplete?()
        }
    }

    @objc public func getUser(onSuccess: @escaping (NSDictionary?) -> Void) {
        guard let user = loginService.user else {
            logInfo("No user is currently bound")
            onSuccess(nil)
            return
        }

        onSuccess(user.dictionary() as NSDictionary)
    }

    @objc public func unbindUser(onComplete: (() -> Void)? = nil) {
        self.loginService.unbindUser()
        onComplete?()
    }

    @objc public func feedbackEvent() {
        showFirstWindow()
        logInfo("Presenting feedback formulary")
        app.presentFeedbackForm()
    }

    @objc public func handleRedirectURL(url: URL) {
        let webview = AppliverySafariManager.shared
        webview.urlReceived(url: url)
    }

    @objc public func checkForUpdates(forceUpdate: Bool = false) {
        startInteractor.checkUpdate(forceUpdate: forceUpdate)
    }

    
    @objc public func disableScreenshotFeedback() {
        logInfo("Disabled screenshot feedback")
        startInteractor.disableFeedback()
    }

    @objc public func enableScreenshotFeedback() {
        logInfo("Enabled screenshot feedback")
        startInteractor.enableFeedback()
    }
    
    @objc public func setCheckForUpdatesBackground(_ enabled: Bool) {
        updateService.setCheckForUpdatesBackground(enabled)
    }
}
// MARK: - SDK Deprecated methods
public extension AppliverySDK {
    /**
     Starts Applivery's framework

     - Parameters:
     - token: Your App Token
     - appStoreRelease: Flag to mark the build as a build that will be submitted to the AppStore. This is needed to prevent unwanted behavior like prompt to a final user that a new version is available on Applivery.
     * `true`: Applivery will stop any activity. **Use this for AppStore**
     * `false`: Applivery will works as normally. Use this with distributed builds in Applivery.
     - Attention: Since apps with Applivery framework are forbidden in the Appstore, the flag `appStoreRelease` has been removed. You can dinamically exclude Applivery framework while compiling an Appstore build as explained [here](https://github.com/applivery/applivery-ios-sdk#dynamically-exclude-applivery-sdk-for-appstore-schemes)
     - Warning: This method is **deprecated** from version 3.3. Use `start(appToken:)` instead
     - Since: 3.0
     - Version: 3.3
     */
    @available(*, deprecated, renamed: "start(token:)")
    @objc func start(token: String, tenant: String?, appStoreRelease: Bool) {
        self.start(token: token, tenant: tenant)
    }

    /**
     Disable Applivery's feedback.

     By default, Applivery will show a feedback formulary to your users when a screenshot is detected. If you want to avoid this, you can disable it calling this method.

     - Since: 1.2
     - Version: 2.0
     */
    @available(*, deprecated, renamed: "disableScreenshotFeedback()")
    @objc func disableFeedback() {
        self.startInteractor.disableFeedback()
    }
}
// MARK: - SDK Private methods
private extension AppliverySDK {
    func showFirstWindow() {
        guard window != nil else {
            window = AppliveryWindow(frame: UIScreen.main.bounds)
            return
        }
    }
}
