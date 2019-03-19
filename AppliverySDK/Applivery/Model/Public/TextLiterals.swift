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
    public var appName: String
    
    
    // MARK: - Alerts
    
    /// "Cancel"
    public var alertButtonCancel: String
    
    /// "Retry
    public var alertButtonRetry: String
    
    /// "OK"
    public var alertButtonOK: String
    
    // Errors
    /// "Unexpected error"
    public var errorUnexpected: String
    
    /// "Invalid credentials"
    public var errorInvalidCredentials: String
    
    /// "Couldn't start download. Invalid url"
    public var errorDownloadURL: String
    
    
    // MARK: - OTA Update
    
    /// "There is a new version available for download. Do you want to update to the latest version?"
    public var otaUpdateMessage: String?
    
    /// "Later"
    public var alertButtonLater: String
    
    /// "Update"
    public var alertButtonUpdate: String
    
    
    // MARK: - Force Update
    
    /// "Sorry this App is outdated. Please, update the App to continue using it"
    public var forceUpdateMessage: String?
    
    /// "Update now"
    public var buttonForceUpdate: String
    
    
    // MARK: - Feedback
    
    /// "Close"
    public var feedbackButtonClose: String
    
    /// "Add feedback"
    public var feedbackButtonAdd: String
    
    /// "Send feedback"
    public var feedbackButtonSend: String
    
    /// "Select type"
    public var feedbackSelectType: String
    
    /// "Bug"
    public var feedbackTypeBug: String
    
    /// "Feedback"
    public var feedbackTypeFeedback: String
    
    /// "Add a message"
    public var feedbackMessagePlaceholder: String
    
    /// "Attach Screenshot"
    public var feedbackAttach: String
    
    // MARK: - Login
    
    /// "email"
    public var loginInputUser: String
    
    /// "password"
    public var loginInputPassword: String
    
    /// "email"
    public var loginButton: String
    
    /// "Login is required!"
    public var loginMessage: String
    
    /// "Wrong username or password, please, try again"
    public var loginInvalidCredentials: String
    
    /// "Your session has expired. Please, log in again"
    public var loginSessionExpired: String
    
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
    public init(appName: String = localize("sdk_name"),
                alertButtonCancel: String = localize("alert_button_cancel"),
                alertButtonRetry: String = localize("alert_button_retry"),
                alertButtonOK: String = localize("alert_button_ok"),
                errorUnexpected: String = localize("error_unexpected"),
                errorInvalidCredentials: String = localize("error_invalid_credentials"),
                errorDownloadURL: String = localize("error_download_url"),
                otaUpdateMessage: String? = nil,
                alertButtonLater: String = localize("alert_button_later"),
                alertButtonUpdate: String = localize("alert_button_update"),
                forceUpdateMessage: String? = nil,
                buttonForceUpdate: String = localize("update_view_button_update"),
                feedbackButtonClose: String = localize("feedback_button_close"),
                feedbackButtonAdd: String = localize("feedback_button_add"),
                feedbackButtonSend: String = localize("feedback_button_send"),
                feedbackSelectType: String = localize("feedback_label_select_type"),
                feedbackTypeBug: String = localize("feedback_button_bug"),
                feedbackTypeFeedback: String = localize("feedback_button_feedback"),
                feedbackMessagePlaceholder: String = localize("feedback_text_message_placeholder"),
                feedbackAttach: String = localize("feedback_label_attach"),
                loginInputUser: String = localize("login_input_user"),
                loginInputPassword: String = localize("login_input_password"),
                loginButton: String = localize("login_button"),
                loginMessage: String = localize("login_alert_message"),
                loginInvalidCredentials: String = localize("login_alert_message_invalid_credentials"),
                loginSessionExpired: String = localize("login_alert_message_expired")) {
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
    case feedbackMessagePlaceholder
    case feedbackAttach
    case loginInputUser
    case loginInputPassword
    case loginButton
    case loginMessage
    case loginInvalidCredentials
    case loginSessionExpired
    
    var description: String {
        return literal(self) ?? String(self.hashValue)
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
