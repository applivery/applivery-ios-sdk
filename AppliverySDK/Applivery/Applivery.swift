//
//  Applivery.swift
//  AppliverySDK
//
//  Created by Alejandro Jiménez on 3/10/15.
//  Copyright © 2015 Applivery S.L. All rights reserved.
//

import Foundation

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

start(apiKey apiKey: String, appId: String, appStoreRelease: Bool)


### Overview

When Applivery's starts, the latests configuration for your build will be retrieved, and the build version of your app will be checked. Then applivery could:
1. Do nothing if the app is in the latest version or any update is checked in the app configuration.
2. Shows a cancellable alert if there is a new available update in Applivery, giving the user the chance to update to the latest build.
3. Shows a modal screen, that user can not dismiss, with the only option to update to the latest build. This will force yours users to update giving them any chance to continue using the app.

- seealso: [Applivery's README on GitHub](https://github.com/applivery/applivery-ios-sdk/blob/master/README.md)
- Since: 1.0
- Version: 2.5.1
- Author: Alejandro Jiménez Agudo
- Copyright: Applivery S.L.
*/
public class Applivery: NSObject, StartInteractorOutput {
	
	// MARK: - Type Properties
	
	/// Singleton instance.
	///
	/// - Warning: This property is **deprecated**. Use `shared` instead
	@available(*, deprecated: 2.3, message: "Use shared instead", renamed: "shared")
	public static let sharedInstance = Applivery()
	
	/// Singleton instance
	@objc public static let shared = Applivery()
	
	
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
	@objc public var logLevel: LogLevel {
		didSet {
			self.globalConfig.logLevel = self.logLevel
		}
	}
	
	/**
	Sets a color for the brush on screenshot edit mode
	
	- Warning: This property is **deprecated**. Use `Palette.screenshotBrushColor` instead
	
	- Since: 2.2
	- Version: 2.4
	*/
	@available(*, deprecated: 2.4, message: "Use palette.screenshotBrushColor instead", renamed: "palette.screenshotBrushColor")
	public var screenshotBrushColor: UIColor? {
		didSet {
			self.globalConfig.palette.screenshotBrushColor = self.screenshotBrushColor ?? self.palette.screenshotBrushColor
		}
	}
	
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
	
	- seealso: `Palette`
	- Since: 2.4
	- Version: 2.4
	*/
	@objc public var palette: Palette {
		didSet {
			self.globalConfig.palette = self.palette
		}
	}
	
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
		feedbackAttach: "Attach Screenshot"
	)
	```
	
	The SDK has literals by default so, if you only need to change the update messages, yo can do this:
	
	```swift
	Applivery.shared.textLiterals = Palette(
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
	- seealso: `TextLiterals`
	- Since: 2.4
	- Version: 2.4
	*/
	public var textLiterals: TextLiterals {
		didSet {
			self.globalConfig.textLiterals = self.textLiterals
		}
	}
	
	// MARK: - Private properties
	internal let startInteractor: StartInteractor
	private let globalConfig: GlobalConfig
	private let updateCoordinator: PUpdateCoordinator
	private let feedbackCoordinator: PFeedbackCoordinator
	
	
	// MARK: Initializers
	override convenience init() {
		self.init(
			startInteractor: StartInteractor(),
			globalConfig: GlobalConfig.shared,
			updateCoordinator: UpdateCoordinator(),
			feedbackCoordinator: FeedbackCoordinator()
		)
		self.startInteractor.output = self
	}
	
	internal init (startInteractor: StartInteractor,
	               globalConfig: GlobalConfig,
	               updateCoordinator: PUpdateCoordinator,
	               feedbackCoordinator: PFeedbackCoordinator) {
		self.startInteractor = startInteractor
		self.globalConfig = globalConfig
		self.updateCoordinator = updateCoordinator
		self.feedbackCoordinator = feedbackCoordinator
		self.logLevel = .none
		self.palette = Palette()
		self.textLiterals = TextLiterals()
		self.globalConfig.palette = self.palette
		self.globalConfig.textLiterals = self.textLiterals
	}
	
	
	// MARK: Instance Methods
	
	/**
	Starts Applivery's framework
	
	- Parameters:
		- apiKey: Your developer's Api Key
		- appId: Your application's ID
		- appStoreRelease: Flag to mark the build as a build that will be submitted to the AppStore. This is needed to prevent unwanted behavior like prompt to a final user that a new version is available on Applivery.
			* `true`: Applivery will stop any activity. **Use this for AppStore**
			* `false`: Applivery will works as normally. Use this with distributed builds in Applivery.
	
	- Attention: Be sure that the param **appStoreRelease** is true before submitting to the AppStore
	- Since: 1.0
	- Version: 2.0
	*/
	@objc public func start(apiKey key: String, appId: String, appStoreRelease: Bool) {
		self.globalConfig.apiKey = key
		self.globalConfig.appId = appId
		self.globalConfig.appStoreRelease = appStoreRelease
		
		self.startInteractor.start()
	}
	
	/**
	Disable Applivery's feedback.
	
	By default, Applivery will show a feedback formulary to your users when a screenshot is detected. If you want to avoid this, you can disable it calling this method
	
	- Since: 1.2
	- Version: 2.0
	*/
	public func disableFeedback() {
		self.startInteractor.disableFeedback()
	}
	
	
	// MARK: Start Interactor
	
	internal func forceUpdate() {
		logInfo("Application must be updated!!")
		self.updateCoordinator.forceUpdate()
	}
	
	internal func otaUpdate() {
		logInfo("New OTA update available!")
		self.updateCoordinator.otaUpdate()
	}
	
	internal func feedbackEvent() {
		logInfo("Presenting feedback formulary")
		self.feedbackCoordinator.showFeedack()
	}
	
	internal func credentialError(message: String) {
		logWarn(message)
	}
	
}
