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
    /**
     Starts Applivery's framework

     - Parameters:
     - token: Your App Token
     - Since: 3.3
     - Version: 3.3
     */
    func start(token: String, tenant: String?, configuration: AppliveryConfiguration, skipUpdateCheck: Bool)

    /**
     Returns if application is updated to the latest version available

     - Since: 3.1
     - Version: 4.5
     */
    func isUpToDate() -> Bool

    /**
     Download newest build available

     - Parameters:
     - onDownload: Completion handler called when success/failure downloading the new version

     - Attention: Be sure to call `start()` before this method.
     - Since: 3.1
     - Version: 4.5.0
     */
    func update(onDownload: ((UpdateResult) -> Void)?)

    /**
     Login a user

     Programatically login a user in Applivery, for example if the app has a custom login and don't want to use Applivery's authentication to track the user in the platform

     - Parameters:
     - email: The user email. **Required**
     - firstName: The first name of the user. **Optional**
     - lastName: The last name of the user. **Optional**
     - tags: A list of tags linked to the user with group / categorize purpose. **Optional**
     - onComplete: Optional callback executed after binding the user. **Optional**

     - SeeAlso: `unbindUser()`
     - Since: 3.0
     - Version: 4.5.0
     */
    func bindUser(email: String, firstName: String?, lastName: String?, tags: [String]?, onComplete: (() -> Void)?)

    /**
     Logout a previously binded user

     Programatically logout a user in Applivery from a previous custom login.

     - Parameter onComplete: Optional callback executed after unbinding the user. **Optional**
     - SeeAlso: `bindUser(email:firstname:lastname:tags)`
     - Since: 3.0
     - Version: 3.0
     */
    func unbindUser(onComplete: (() -> Void)?)

    /**
     Get the currently bound user information

     Retrieves the user information that was previously bound using `bindUser` method. Returns the user info as a dictionary if available, or nil if no user is currently bound.

     - Parameter onSuccess: Callback with NSDictionary containing user info, or nil if no user is bound
     - SeeAlso: `bindUser(email:firstname:lastname:tags)`
     - Since: 4.5
     - Version: 4.5
     */
    func getUser(onSuccess: @escaping (NSDictionary?) -> Void)

    /**
     Present in an alert view the Applivery's feedback.

     By default, Applivery will show a feedback formulary to your users when a screenshot is detected. If you want to do it programatically controlled by your app (for example in a shake event), you can call this method. Also you may want to prevent the feedback view to be show when a screenshot event is produced, for that you can call `disableFeedback()` method

     - SeeAlso: `disableFeedback()`
     - Since: 2.7
     - Version: 4.5.0
     */
    func feedbackEvent()

    /**
     Handles a given redirect URL as part of the SAML authentication flow.

     When implementing SAML-based authentication, your app may receive a redirect URL
     after the user completes their authentication on an external SAML identity provider.
     By calling this method, you pass that redirect URL to `AppliverySafariManager` to
     proceed with the final steps of the authentication flow.

     - Parameter url: The redirect `URL` returned by the SAML provider.
     - Since: 4.1.0
     - Version: 4.1.0
     */
    func handleRedirectURL(url: URL)

    /**
     Checks if updates are available and launches the update flow if they are

     - Parameter forceUpdate: The `forceUpdate`allows ignore or not the postponed time.
     - Since: 4.1.0
     - Version: 4.5.0
     */
    func checkForUpdates(forceUpdate: Bool)

    /**
     Disables listening for screenshot events to trigger the feedback action
     - Since 4.5.0
     - Version 4.5.0
     */
    func disableScreenshotFeedback()

    /**
     Enables the listener for screenshot events to trigger the feedback action
     - Since 4.5.0
     - Version 4.5.0
     */
    func enableScreenshotFeedback()

    /**
     Enables checking for updates automatically when the app returns from background
     - Since 4.5.0
     - Version 4.5.0
     */
    func setCheckForUpdatesBackground(_ enabled: Bool)
}
