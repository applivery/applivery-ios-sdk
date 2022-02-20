//
//  TextLiterals.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez Agudo on 26/3/17.
//  Copyright © 2017 Applivery S.L. All rights reserved.
//

import Foundation

/**
 A set of string literals to customize all the Applivery's texts
 
 # Overview
 You can customize the SDK's texts by setting the properties of this class.
 
 # Example
 
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
 feedbackEmailPlaceholder: "Add  your email (optional)",
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
 
 - seealso: `Applivery.textLiterals`
 - Since: 2.4
 - Version: 2.4
 - Author: Alejandro Jiménez Agudo
 - Copyright: Applivery S.L.
 */
public class TextLiterals: NSObject {
    
    // MARK: - General
    
    /// The application name. **default**: "Applivery"
    @objc public var appName: String
    
    
    // MARK: - Alerts
    
    /// "Cancel"
    @objc public var alertButtonCancel: String
    
    /// "Retry
    @objc public var alertButtonRetry: String
    
    /// "OK"
    @objc public var alertButtonOK: String
    
    // Errors
    /// "Unexpected error"
    @objc public var errorUnexpected: String
    
    /// "Invalid credentials"
    @objc public var errorInvalidCredentials: String
    
    /// "Couldn't start download. Invalid url"
    @objc public var errorDownloadURL: String
    
    
    // MARK: - OTA Update
    
    /// "There is a new version available for download. Do you want to update to the latest version?"
    @objc public var otaUpdateMessage: String?
    
    /// "Later"
    @objc public var alertButtonLater: String
    
    /// "Update"
    @objc public var alertButtonUpdate: String
    
    
    // MARK: - Force Update
    
    /// "Sorry this App is outdated. Please, update the App to continue using it"
    @objc public var forceUpdateMessage: String?
    
    /// "Update now"
    @objc public var buttonForceUpdate: String
    
    
    // MARK: - Feedback
    
    /// "Close"
    @objc public var feedbackButtonClose: String
    
    /// "Add feedback"
    @objc public var feedbackButtonAdd: String
    
    /// "Send feedback"
    @objc public var feedbackButtonSend: String
    
    /// "Select type"
    @objc public var feedbackSelectType: String
    
    /// "Bug"
    @objc public var feedbackTypeBug: String
    
    /// "Feedback"
    @objc public var feedbackTypeFeedback: String
    
    /// "Add  your email (optional)"
    @objc public var feedbackEmailPlaceholder: String
    
    /// "Add a message"
    @objc public var feedbackMessagePlaceholder: String
    
    /// "Attach Screenshot"
    @objc public var feedbackAttach: String
    
    // MARK: - Login
    
    /// "email"
    @objc public var loginInputUser: String
    
    /// "password"
    @objc public var loginInputPassword: String
    
    /// "email"
    @objc public var loginButton: String
    
    /// "Login is required!"
    @objc public var loginMessage: String
    
    /// "Wrong username or password, please, try again"
    @objc public var loginInvalidCredentials: String
    
    /// "Your session has expired. Please, log in again"
    @objc public var loginSessionExpired: String
    
    // MARK: - Initializer
    /**
     Creates a new instance of TextLiterals.
     
     - Parameters:
     - appName: "Applivery"
     - alertButtonCancel: "Cancel"
     - alertButtonRetry: "Retry"
     - alertButtonOK: "OK"
     - errorUnexpected: "Unexpected error"
     - errorInvalidCredentials: "Invalid credentials"
     - errorDownloadURL: "Couldn't start download. Invalid url",
     - otaUpdateMessage: "There is a new version available for download. Do you want to update to the latest version?",
     - alertButtonLater: "Later",
     - alertButtonUpdate: "Update",
     - forceUpdateMessage: "Sorry this App is outdated. Please, update the App to continue using it",
     - buttonForceUpdate: "Update now",
     - feedbackButtonClose: "Close",
     - feedbackButtonAdd: "Add Feedback",
     - feedbackButtonSend: "Send Feedback",
     - feedbackSelectType: "Select type",
     - feedbackTypeBug: "Bug",
     - feedbackTypeFeedback: "Feedback",
     - feedbackEmailPlaceholder: "Add  your email (optional)",
     - feedbackMessagePlaceholder: "Add a message",
     - feedbackAttach: "Attach Screenshot",
     - loginInputUser: "user",
     - loginInputPassword: "password",
     - loginButton: "Login",
     - loginMessage: "Login is required!",
     - loginInvalidCredentials: "Wrong user or password, please, try again",
     - loginSessionExpired: "Your session has expired. Please, log in again"
     - Note: Each parameter has a default literal, so you could set only the values that you really need to change
     - Since: 2.4
     - Version: 2.4
     */
    @objc public init(
        appName: String = kLocaleSdkName,
        alertButtonCancel: String = kLocaleAlertButtonCancel,
        alertButtonRetry: String = kLocaleAlertButtonRetry,
        alertButtonOK: String = kLocaleAlertButtonOk,
        errorUnexpected: String = kLocaleErrorUnexpected,
        errorInvalidCredentials: String = kLocaleErrorInvalidCredentials,
        errorDownloadURL: String = kLocaleErrorDownloadUrl,
        otaUpdateMessage: String? = nil,
        alertButtonLater: String = kLocaleAlertButtonLater,
        alertButtonUpdate: String = kLocaleAlertButtonUpdate,
        forceUpdateMessage: String? = nil,
        buttonForceUpdate: String = kLocaleUpdateViewButtonUpdate,
        feedbackButtonClose: String = kLocaleFeedbackButtonClose,
        feedbackButtonAdd: String = kLocaleFeedbackButtonAdd,
        feedbackButtonSend: String = kLocaleFeedbackButtonSend,
        feedbackSelectType: String = kLocaleFeedbackLabelSelectType,
        feedbackTypeBug: String = kLocaleFeedbackButtonBug,
        feedbackTypeFeedback: String = kLocaleFeedbackButtonFeedback,
        feebackEmailPlaceholder: String = kLocaleFeedbackEmailPlaceholder,
        feedbackMessagePlaceholder: String = kLocaleFeedbackTextMessagePlaceholder,
        feedbackAttach: String = kLocaleFeedbackLabelAttach,
        loginInputUser: String = kLocaleLoginInputUser,
        loginInputPassword: String = kLocaleLoginInputPassword,
        loginButton: String = kLocaleLoginButton,
        loginMessage: String = kLocaleLoginAlertMessage,
        loginInvalidCredentials: String = kLocaleLoginAlertMessageInvalidCredentials,
        loginSessionExpired: String = kLocaleLoginAlertMessageExpired) {
            self.appName = appName
            self.alertButtonCancel = alertButtonCancel
            self.alertButtonRetry = alertButtonRetry
            self.alertButtonOK = alertButtonOK
            self.errorUnexpected = errorUnexpected
            self.errorInvalidCredentials = errorInvalidCredentials
            self.errorDownloadURL = errorDownloadURL
            self.otaUpdateMessage = otaUpdateMessage
            self.alertButtonLater = alertButtonLater
            self.alertButtonUpdate = alertButtonUpdate
            self.forceUpdateMessage = forceUpdateMessage
            self.buttonForceUpdate = buttonForceUpdate
            self.feedbackButtonClose = feedbackButtonClose
            self.feedbackButtonAdd = feedbackButtonAdd
            self.feedbackButtonSend = feedbackButtonSend
            self.feedbackSelectType = feedbackSelectType
            self.feedbackTypeBug = feedbackTypeBug
            self.feedbackTypeFeedback = feedbackTypeFeedback
            self.feedbackEmailPlaceholder = feebackEmailPlaceholder
            self.feedbackMessagePlaceholder = feedbackMessagePlaceholder
            self.feedbackAttach = feedbackAttach
            self.loginInputUser = loginInputUser
            self.loginInputPassword = loginInputPassword
            self.loginButton = loginButton
            self.loginMessage = loginMessage
            self.loginInvalidCredentials = loginInvalidCredentials
            self.loginSessionExpired = loginSessionExpired
        }
}

enum Literal: CustomStringConvertible {
    case appName
    case alertButtonCancel
    case alertButtonRetry
    case alertButtonOK
    case errorUnexpected
    case errorInvalidCredentials
    case errorDownloadURL
    case otaUpdateMessage
    case alertButtonLater
    case alertButtonUpdate
    case forceUpdateMessage
    case buttonForceUpdate
    case feedbackButtonClose
    case feedbackButtonAdd
    case feedbackButtonSend
    case feedbackSelectType
    case feedbackTypeBug
    case feedbackTypeFeedback
    case feedbackEmailPlaceholder
    case feedbackMessagePlaceholder
    case feedbackAttach
    case loginInputUser
    case loginInputPassword
    case loginButton
    case loginMessage
    case loginInvalidCredentials
    case loginSessionExpired
    
    var description: String {
        literal(self) ?? String(self.hashValue)
    }
}

// swiftlint:disable cyclomatic_complexity
func literal(_ literal: Literal) -> String? {
    let literals = GlobalConfig.shared.textLiterals
    
    switch literal {
    case .appName: return literals.appName
    case .alertButtonCancel: return literals.alertButtonCancel
    case .alertButtonRetry: return literals.alertButtonRetry
    case .alertButtonOK: return literals.alertButtonOK
    case .errorUnexpected: return literals.errorUnexpected
    case .errorInvalidCredentials: return literals.errorInvalidCredentials
    case .errorDownloadURL: return literals.errorDownloadURL
    case .otaUpdateMessage: return literals.otaUpdateMessage
    case .alertButtonLater: return literals.alertButtonLater
    case .alertButtonUpdate: return literals.alertButtonUpdate
    case .forceUpdateMessage: return literals.forceUpdateMessage
    case .buttonForceUpdate: return literals.buttonForceUpdate
    case .feedbackButtonClose: return literals.feedbackButtonClose
    case .feedbackButtonAdd: return literals.feedbackButtonAdd
    case .feedbackButtonSend: return literals.feedbackButtonSend
    case .feedbackSelectType: return literals.feedbackSelectType
    case .feedbackTypeBug: return literals.feedbackTypeBug
    case .feedbackTypeFeedback: return literals.feedbackTypeFeedback
    case .feedbackEmailPlaceholder: return literals.feedbackEmailPlaceholder
    case .feedbackMessagePlaceholder: return literals.feedbackMessagePlaceholder
    case .feedbackAttach: return literals.feedbackAttach
    case .loginInputUser: return literals.loginInputUser
    case .loginInputPassword: return literals.loginInputPassword
    case .loginButton: return literals.loginButton
    case .loginMessage: return literals.loginMessage
    case .loginInvalidCredentials: return literals.loginInvalidCredentials
    case .loginSessionExpired: return literals.loginSessionExpired
    }
}
// swiftlint:enable cyclomatic_complexity
