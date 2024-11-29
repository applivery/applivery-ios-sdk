//
//  Applivery.swift
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
 - Version: 3.3
 - Author: Alejandro Jiménez Agudo
 - Copyright: Applivery S.L.
 */
public class Applivery: NSObject, StartInteractorOutput, UpdateInteractorOutput {
    
    // MARK: - Static Properties
    
    internal static let sdkVersion = "3.4.0"
    
    // MARK: - Type Properties
    
    /// Singleton instance
    @objc public static let shared = Applivery()
    
    var window: AppliveryWindow?
    
    // MARK: - Instance Properties
    
    /**
     Type of Applivery's logs you want displayed in the debug console
     
     * **none**: No log will be shown. Recommended for production environments.
     * **error**: Only warnings and errors. Recommended for develop environments.
     * **info**: Errors and relevant information. Recommended for test integrating Applivery.
     * **debug**: Request and Responses to Applivery's server will be displayed. Not recommended to use, only for debugging Applivery.
     
     - Since: 1.0
     - Version: 2.0
     */
    @objc public var logLevel: LogLevel { didSet {
        self.globalConfig.logLevel = self.logLevel
    }}
    
    /**
     Customize the SDK colors to fit your app
     
     # Examples
     
     You can create a new instance of `Palette` and assign it to this property
     
     ```swift
     Applivery.shared.palette = Palette(
     primaryColor: .orange,
     secondaryColor: .white,
     primaryFontColor: .white,
     secondaryFontColor: .black,
     screenshotBrushColor: .green
     )
     ```
     
     The SDK has Applivery's colors by default so, if you only need to change the primary color, yo can do this:
     
     ```swift
     Applivery.shared.palette = Palette(
     primaryColor: .orange,
     )
     ```
     
     Or even directly change the property
     
     ```swift
     Applivery.shared.palette.primaryColor = .orange
     ```
     
     - SeeAlso: `Palette`
     - Since: 2.4
     - Version: 2.4
     */
    @objc public var palette: Palette { didSet {
        self.globalConfig.palette = self.palette
    }}
    
    /**
     Customize the SDK string literals to fit your app.
     
     By default, Applivery has english literals.
     
     # Examples
     
     You can create a new instance of `TextLiterals` and assign it to this property
     
     ```swift
     Applivery.shared.textLiterals = TextLiterals(
     appName: "Applivery",
     alertButtonCancel: "Cancel",
     alertButtonRetry: "Retry",
     alertButtonOK: "OK",
     errorUnexpected: "Unexpected error",
     errorInvalidCredentials: "Invalid credentials",
     errorDownloadURL: "Couldn't start download. Invalid url",
     otaUpdateMessage: "There is a new version available for download. Do you want to update to the latest version?",
     alertButtonLater: "Later",
     alertButtonUpdate: "Update",
     forceUpdateMessage: "Sorry this App is outdated. Please, update the App to continue using it",
     buttonForceUpdate: "Update now",
     feedbackButtonClose: "Close",
     feedbackButtonAdd: "Add Feedback",
     feedbackButtonSend: "Send Feedback",
     feedbackSelectType: "Select type",
     feedbackTypeBug: "Bug",
     feedbackTypeFeedback: "Feedback",
     feedbackMessagePlaceholder: "Add a message",
     feedbackAttach: "Attach Screenshot",
     loginInputUser: "user",
     loginInputPassword: "password",
     loginButton: "Login",
     loginMessage: "Login is required!",
     loginInvalidCredentials: "Wrong username or password, please, try again",
     loginSessionExpired: "Your session has expired. Please, log in again"
     )
     ```
     
     The SDK has literals by default so, if you only need to change the update messages, yo can do this:
     
     ```swift
     Applivery.shared.textLiterals = TextLiterals(
     appName: "MyApp",
     otaUpdateMessage: "There is a new version available for download. Do you want to update to the latest version?",
     forceUpdateMessage: "Sorry this App is outdated. Please, update the App to continue using it"
     )
     ```
     
     Or even directly change the property
     
     ```swift
     Applivery.shared.textLiterals.appName: "MyApp"
     Applivery.shared.textLiterals.otaUpdateMessage: "There is a new version available for download. Do you want to update to the latest version?"
     Applivery.shared.textLiterals.forceUpdateMessage: "Sorry this App is outdated. Please, update the App to continue using it"
     ```
     
     - Important: The default literals are only in english. Consider to set localized strings to fully support all languages your app does.
     - SeeAlso: `TextLiterals`
     - Since: 2.4
     - Version: 2.4
     */
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
    
    
    // MARK: - Private properties
    internal let startInteractor: StartInteractor
    internal var updateInteractor: PUpdateInteractor
    private let globalConfig: GlobalConfig
    private let updateCoordinator: PUpdateCoordinator
    private let loginInteractor: LoginInteractor
    private let app: AppProtocol
    private let environments: EnvironmentProtocol
    private var isUpdating = false
    private var updateCallbackSuccess: (() -> Void)?
    private var updateCallbackError: ((String) -> Void)?
    
    
    // MARK: Initializers
    override convenience init() {
        self.init(
            startInteractor: StartInteractor(),
            globalConfig: GlobalConfig.shared,
            updateCoordinator: UpdateCoordinator(),
            updateInteractor: Configurator.updateInteractor(),
            loginInteractor: Configurator.loginInteractor(),
            app: App(),
            environments: Environments()
        )
        self.startInteractor.output = self
        self.updateInteractor.output = self
    }
    
    internal init (startInteractor: StartInteractor,
                   globalConfig: GlobalConfig,
                   updateCoordinator: PUpdateCoordinator,
                   updateInteractor: PUpdateInteractor,
                   loginInteractor: LoginInteractor,
                   app: AppProtocol,
                   environments: EnvironmentProtocol) {
        self.startInteractor = startInteractor
        self.globalConfig = globalConfig
        self.updateCoordinator = updateCoordinator
        self.updateInteractor = updateInteractor
        self.loginInteractor = loginInteractor
        self.app = app
        self.environments = environments
        self.logLevel = .info
        self.palette = Palette()
        self.textLiterals = TextLiterals()
        self.globalConfig.palette = self.palette
        self.globalConfig.textLiterals = self.textLiterals
    }
    
    
    // MARK: Instance Methods
    
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
    @objc public func start(token: String, tenant: String?, appStoreRelease: Bool) {
        self.start(token: token, tenant: tenant)
    }
    
    /**
     Starts Applivery's framework
     
     - Parameters:
     - token: Your App Token
     - Since: 3.3
     - Version: 3.3
     */
    @objc public func start(token: String, tenant: String? = nil) {
        self.globalConfig.appToken = token
        host = tenant
        hostDownload = tenant
        self.startInteractor.start()
        showFirstWindow()
    }
    
    func showFirstWindow() {
        window = AppliveryWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
    }
    
    /**
     Returns if application is updated to the latest version available
     
     - Since: 3.1
     - Version: 3.1
     */
    @objc public func isUpToDate() -> Bool {
        return self.updateInteractor.isUpToDate()
    }
    
    /**
     Download newest build available
     
     - Parameters:
     - onSuccess: Completion handler called when success
     - onError: Completion handler called when something went wrong. A string whith the reason is passed to this callback.
     
     - Attention: Be sure to call `start(token:appStoreRelease)` before this method.
     - Since: 3.1
     - Version: 3.1
     */
    @objc public func update(onSuccess: (() -> Void)? = nil, onError: ((String) -> Void)? = nil) {
        guard !isUpdating else {
            return logWarn("Can't call update method until previous call is finished")
        }
        self.isUpdating = true
        self.updateCallbackSuccess = onSuccess
        self.updateCallbackError = onError
        self.updateInteractor.downloadLastBuild()
    }
    
    /**
     Login a user
     
     Programatically login a user in Applivery, for example if the app has a custom login and don't want to use Applivery's authentication to track the user in the platform
     
     - Parameters:
     - email: The user email. **Required**
     - firstName: The first name of the user. **Optional**
     - lastName: The last name of the user. **Optional**
     - tags: A list of tags linked to the user with group / categorize purpose. **Optional**
     
     - SeeAlso: `unbindUser()`
     - Since: 3.0
     - Version: 3.1.1
     */
    @objc public func bindUser(email: String, firstName: String? = nil, lastName: String? = nil, tags: [String]? = nil) {
        let compactedTags = tags?.compactMap(removeEmpty) // Example: ["", "aaa", ""] -> ["aaa"]
        let user = User(
            email: email,
            firstName: firstName,
            lastName: lastName,
            tags: compactedTags
        )
        user.log()
        self.loginInteractor.bind(user)
    }
    
    /**
     Logout a previously binded user
     
     Programatically logout a user in Applivery from a previous custom login.
     
     - SeeAlso: `bindUser(email:firstname:lastname:tags)`
     - Since: 3.0
     - Version: 3.0
     */
    @objc public func unbindUser() {
        self.loginInteractor.unbindUser()
    }
    
    /**
     Disable Applivery's feedback.
     
     By default, Applivery will show a feedback formulary to your users when a screenshot is detected. If you want to avoid this, you can disable it calling this method.
     
     - Since: 1.2
     - Version: 2.0
     */
    @objc public func disableFeedback() {
        self.startInteractor.disableFeedback()
    }
    
    /**
     Present in a modal view the Applivery's feedback.
     
     By default, Applivery will show a feedback formulary to your users when a screenshot is detected. If you want to do it programatically controlled by your app (for example in a shake event), you can call this method. Also you may want to prevent the feedback view to be show when a screenshot event is produced, for that you can call `disableFeedback()` method
     
     - SeeAlso: `disableFeedback()`
     - Since: 2.7
     - Version: 2.7
     */
    @objc public func feedbackEvent() {
        logInfo("Presenting feedback formulary")
        app.presentFeedbackForm()
    }
    
    
    // MARK: Start Interactor Delegate
    
    internal func forceUpdate() {
        logInfo("Application must be updated!!")
        self.updateCoordinator.forceUpdate()
    }
    
    internal func otaUpdate() {
        logInfo("New OTA update available!")
        self.updateCoordinator.otaUpdate()
    }
    
    internal func credentialError(message: String) {
        log(message)
        log("App Token you did set: \(GlobalConfig.shared.appToken)")
    }
    
    
    // MARK: - Update Interactor Delegate
    
    func downloadDidEnd() {
        self.updateCallbackSuccess?()
        self.isUpdating = false
    }
    
    func downloadDidFail(_ message: String) {
        self.updateCallbackError?(message)
        logWarn("Update did fail: \(message)")
        self.isUpdating = false
    }
    
}
