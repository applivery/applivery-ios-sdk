![Applivery Logo](https://www.applivery.com/wp-content/uploads/2019/06/applivery-og.png)

![Version](https://img.shields.io/badge/version-4.1.0-blue.svg)
![Minimum iOS Version](https://img.shields.io/badge/iOS-15.0%2B-blue.svg)
![Language](https://img.shields.io/badge/Language-Swift-orange.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Applivery.svg)](https://cocoapods.org/pods/Applivery)
[![Fastlane Plugin](https://img.shields.io/badge/Fastlane_Plugin-available-brightgreen.svg)](https://github.com/fastlane-community/fastlane-plugin-applivery)
[![Twitter](https://img.shields.io/badge/twitter-@Applivery-blue.svg?style=flat)](https://twitter.com/Applivery)

### Quality checks

[![Swift](https://github.com/applivery/applivery-ios-sdk/actions/workflows/swift.yml/badge.svg?branch=master)](https://github.com/applivery/applivery-ios-sdk/actions/workflows/swift.yml)
[![codecov](https://codecov.io/gh/applivery/applivery-ios-sdk/branch/develop/graph/badge.svg)](https://codecov.io/gh/applivery/applivery-ios-sdk)

### Table of Contents

- [Overview](#overview)
- [Getting Started](#getting-started)
- [SDK Installation](#sdk-installation)
  - [Using SwiftPM](#using-swift-package-manager)
  - [Using Carthage](#using-carthage)
  - [Using CocoaPods](#using-cocoapods)
  - [Manual installation](#manual-installation)
  - [Objective-C](#objective-c)
- [SDK Setup](#sdk-setup)
  - [Swift](#swift)
  - [Objective-C](#objective-c-1)
  - [About params](#about-params)
- [Swift & Xcode versions support](#swift--xcode-version-support)
- [Advanced concepts](#advanced-concepts)

# Overview

Applivery iOS SDK is a Framework to support [Applivery.com Mobile App distribution](http://www.applivery.io) for iOS Apps.

With Applivery you can massively distribute your iOS Apps (both Ad-hoc or In-House/Enterprise) through a customizable distribution site with no need of your users have to be registered in the platform. Combined with [Apple Developer Enterprise Program](https://developer.apple.com/programs/enterprise/) and Enterprise certificates, Applivery is perfect not only for beta testing distribute to your QA team, but also for In-House Enterprise distribution for beta testing users, prior to a release, or even for corporative Apps to the employees of a company.

## Features

- **Automatic OTA Updates** when uploading new versions to Applivery.
- **Force update** if App version is lower than the minimum version configured in Applivery.
- **Employee authentication**. You can login yours employees in order to track analytics of installations, block app usage, to know who sent a feedback or report, etc..
- **Send feedback**. Your test users can report bugs or suggest improvements by:
  - **Taking a screenshot** (triggers feedback by default). On iOS 15.0+, users can also annotate the screenshot before sending it.
  - **Recording a video** for better context.
  
  A bottom sheet will be displayed allowing the user to choose between sending a screenshot or recording a video. This behavior is enabled by default and managed through the `EventDetector` class, which listens for system screenshot events.

  If you want to disable this feature entirely, you can use:
  
  ```swift
  applivery.disableFeedback()
  
# Getting Started

First of all, you should create an account on [Applivery.io](https://dashboard.applivery.io) and then add a new Application.

## Get your credentials

**API TOKEN**: that identifies and grants access to your account in order to use the SDK.

You can get your API TOKEN in your `App -> Settings -> API Auth` section.

## SDK Installation

### Using Swift Package Manager

(**RECOMMENDED**)

In the Xcode menu, you just need to open “File -> Add Package Dependencies...” and enter the Github url: https://github.com/applivery/applivery-ios-sdk.git

then we recommend to configure the dependency rule as "Up to next major version" (4.0.0 < 5.0.0).

At this point, you should choose **one** of the following sdk versions:

- Applivery
- AppliveryDynamic

Select `Applivery` if your app is for internal use only. For example, an in-house business app for your employees (your not going to upload it to the Appstore). This is a static version of the library.

**Publish an app with the Applivery SDK in the Appstore is forbidden** and your build may be rejected at review process. You should manually delete Applivery each time you upload to the Appstore, or you can use the AppliveryDynamic framework and excluding it at build time.

---

### Dynamically exclude Applivery SDK for Appstore schemes

Select `AppliveryDynamic` if you are using Applivery for internal beta testing and eventually you are going to upload a build to the Appstore. With this dynamic framework version, you could dynamically exclude applivery when compiling a build for the Appstore.

### Step 1

First add the framework with "Embed & Sign" flag (under "<Your Target\>" -> "General" -> "Frameworks, Libraries, and Embedded Content") and be sure that it is included in "Build Phases" -> "Embed Frameworks"

### Step 2

Then change the linking option from `required` to `optional` in "Build Phases" -> "Link Binary With Libraries"

### Step 3

Now, you can exclude `AppliveryDynamic.framework` in the "Exclude Source Filenames" build option for your appstore configuration in the build settings. Alternatively to this step, if your are using **xcconfig** files (this is our recommendation) you can ignore the framework adding the following line to your xcconfig:

```
EXCLUDED_SOURCE_FILE_NAMES = AppliveryDynamic.framework
```

### Step 4

Finally you may also exclude source code that invokes applivery methods at build time using Swift macros. For example:

```swift
#if !APPSTORE && !DEBUG
import Applivery
#endif

struct AppliveryWrapper {

  func setup() {
#if !APPSTORE && !DEBUG
    let applivery = AppliverySDK.shared
    applivery.logLevel = .info
    applivery.start(token: APPLIVERY_TOKEN, appStoreRelease: false)
#endif
	}

}
```

The lines between the `#if` macros will not compile (as they wouldn't exists) if you are compiling for a build configuration that has those `Swift Compiler - Custom Flags` (you can add/edit them in the Build settings)

You can find a tutorial about dynamically excluding Applivery for an AppStore scheme [here](https://www.applivery.com/docs/troubleshooting/exclude-applivery-ios-sdk/)

### Troubleshooting

Beware if you are using a script for removing simulator slices of dynamic frameworks [like this](https://github.com/applivery/applivery-ios-sdk/blob/master/script/applivery_script.sh). Xcode only build the framework for the configuration selected, so when archiving a release configuration, no simulator slice is generated inside the framework and the script may fail or remove the applivery framework itself. You should ignore AppliveryDynamic in this kind of scripts (commonly used with carthage)

---

### Using Carthage

(deprecated)

Install carthage with using brew

```bash
brew update && brew install carthage
```

Add the following line to your's Cartfile

```bash
github "applivery/applivery-ios-sdk" ~> 3.3
```

Run `carthage update` and then drag the built framework into your project.

More info about Carthage [here](https://github.com/Carthage/Carthage#installing-carthage).

### Using CocoaPods

(deprecated)

Install the ruby gem

```bash
gem install cocoapods
```

Add the following line to your's Podfile

```ruby
project '<Your Project Name>.xcodeproj'

# Uncomment the next line to define a global platform for your project
# platform :ios, '11.0'
# use_frameworks!  # Starting from v3.2 you can use applivery as a static framework, leave this line commented if you wish
target '<Your Target Name>' do
  pod 'Applivery', '~> 3.3'
end
```

and then run `pod install`. More info about CocoaPods [here](https://cocoapods.org)

## SDK Setup

At your application start up (for example in the _AppDelegate_) add the following code:

### Swift

First import the module:

```swift
import Applivery
```

and then the magic:

```swift
let applivery = AppliverySDK.shared
applivery.start(token: "YOUR_TOKEN", appStoreRelease: false)
```

### Objective-C

The import:

```objc
@import Applivery;
```

The magic:

```objc
AppliverySDK *applivery = [AppliverySDK shared];
[applivery startWithToken:@"YOUR_TOKEN" appStoreRelease:NO];
```

**IMPORTANT I:** As you can suspect, you should replace the string `YOUR_TOKEN` with your token. Easy! Don't you think so?

**IMPORTANT II:** If you are experimenting problems submitting your app to the AppStore, please check this known issue about [Embedded Frameworks and AppStore submissions](https://github.com/applivery/applivery-ios-sdk#embedded-frameworks-and-appstore-submissions)

### About params

- **token**: Your app token
- **appStoreRelease**: (DEPRECATED - You should not upload a build with Applivery to the Appstore)

## Swift & Xcode version support

The compatibility version is as follow:

| Applivery Version | Xcode Version | Swift Version |
| ----------------- | ------------- | ------------- |
| **v1.2.x**        | 7.x           | 2.0, 2.1, 2.2 |
| **v1.3.x**        | 8.x           | 2.3           |
| **v2.x**          | 8.x, 9.x      | 3.0, 3.1, 4.0 |
| **v2.7.x**        | 9.x, 10.x     | 4.0, 4.2      |
| **v3.0**          | 10.x, 11.x    | 4.0, 4.2, 5.0 |
| **v3.1**          | 11.x          | 4.0, 4.2, 5.x |
| **v3.2**          | 12.x          | 5.x           |
| **v3.3**          | 13.x          | 5.X           |
| **v3.4**          | 13.x          | 5.X           |
| **v4.0**          | 13.x          | 5.X           |
| **v4.0.x**        | 13.x          | 5.X           |

# Advanced concepts

## Logs and debugging

In some cases you'll find usefull to see what is happening inside Applivery SDK. If so, you can enable logs for debugging purposes.

### Swift

```swift
applivery.logLevel = .info
```

### Objective-C

```objc
applivery.logLevel = LogLevelInfo;
```

Possible values are:

- **None**: Default value. No logs will be shown. Recommended for production environments.
- **Error**: Only warnings and errors. Recommended for develop environments.
- **Info**: Errors and relevant information. Recommended for test integrating Applivery.
- **Debug**: Request and Responses to Applivery's server will be displayed. Not recommended to use, only for debugging Applivery.

## Disable feedback

By default, Applivery will show a feedback formulary to your users when a screenshot is detected. If you want to avoid this, you can disable it calling the following method:

### Swift

```swift
applivery.disableFeedback()
```

### Objective-C

```objc
[applivery disableFeedback];
```

## Bind User

Programatically login a user in Applivery. If your app has a custom login and you need to track the user in the platform. Used for know who has downloaded a build or who sent a feedback report.

```swift
applivery.bindUser(
    email: "user@email.com",  // Required
    firstName: "John",        // Optional
    lastName: "Doe",          // Optional
    tags: [ios, testers]      // Optional
)
```

## Unbind User

Logout a previously binded user

```swift
applivery.unbindUser()
```

## Implement your own Update Alert/Screen

You can customize the update process to be fully controlled by your app. In order to achive that, first you must disable automatic updates in the settings of your app in Applivery's dashboard. Then you can use the following SDK methods:

```swift
func isUpToDate() -> Bool
```

With this function you can check if application is updated to the latest version available.

### Swift

```swift
self.applivery.update { result in
            switch result.type {
            case .success:
                print("Success")
            case .error:
		print("Error: \(result.error)")
		/// or you can handle the error
                switch result.error {
                case .authRequired:
                    /// More cases bellow
                default:
                    print("Error: \(result.error)")
                }
            }
        }
```

### Objective-C

```objc
[[AppliverySDK shared] updateOnResult:^(UpdateResult * _Nonnull result) {
            switch (result.type) {
                case UpdateResultTypeSuccess:
                    NSLog(@"Success");
                case UpdateResultTypeError:
                    NSLog(@"Error: %ld", (long)result.error);
            }
        }];
```

Use this method to download and install the newest build available.

## Customize SDK's colors

You can create a new instance of `Palette` class and assign it to `AppliverySDK.shared.palette`

```swift
AppliverySDK.shared.palette = Palette(
    primaryColor: .orange,
    secondaryColor: .white,
    primaryFontColor: .white,
    secondaryFontColor: .black,
    screenshotBrushColor: .green
)
```

The SDK has Applivery's colors by default so, if you only need to change the primary color, yo can do this:

```swift
AppliverySDK.shared.palette = Palette(
    primaryColor: .orange,
)
```

Or even directly change the property

```swift
AppliverySDK.shared.palette.primaryColor = .orange
```

### Colors you can change

- `primaryColor`: Main color of your brand
- `secondaryColor`: Background color
- `primaryFontColor`: Primary font color. It should be in contrast with the primary color
- `secondaryFontColor`: Secondary font color. It should be in contrast with the secondary color
- `screenshotBrushColor`: In the feedback's view, users can edit the screenshot to draw lines on top of it. By default, these lines are red, but you are allowed to change the color to fit better with your application's color palette.

## Customize string literals

You can customize the SDK string literals to fit your app.

### Examples

```swift
AppliverySDK.shared.textLiterals = TextLiterals(
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
AppliverySDK.shared.textLiterals = TextLiterals(
    appName: "MyApp",
    otaUpdateMessage: "There is a new version available for download. Do you want to update to the latest version?",
    forceUpdateMessage: "Sorry this App is outdated. Please, update the App to continue using it"
)
```

Or even directly change the property

```swift
AppliverySDK.shared.textLiterals.appName: "MyApp"
AppliverySDK.shared.textLiterals.otaUpdateMessage: "There is a new version available for download. Do you want to update to the latest version?"
AppliverySDK.shared.textLiterals.forceUpdateMessage: "Sorry this App is outdated. Please, update the App to continue using it"
```

_**Important**_: The default literals are only in english. Consider to set localized strings to fully support all languages your app does.

## Embedded frameworks & ipa generation

If you have installed the SDK with Carthage and as a Dynamic framework, Applivery.framework is built as a fat universal library, that means that you can compile for devices or simulator without any problem, but you can not make an ipa file if it has inside an embedded framework with simulator slices.

In this case, the solution is as simple as add [this script](https://github.com/applivery/applivery-ios-sdk/blob/master/script/applivery_script.sh) in "New Run Script Phase".
You'll find inside _Build Phases_ tab.

# Configuring a Custom Host

If you need to point the Applivery SDK to a custom server host—for example, for testing purposes or to use a private instance—you can now configure it directly through the SDK's `start` method. Follow the steps below to set up a custom host:

## Step 1: Import Applivery SDK

Ensure you have the Applivery SDK imported in your project:

```swift
import Applivery
```

## Step 2: Update the SDK Start Method

In your application code, where you initialize the Applivery SDK (typically in your `AppDelegate` or `SceneDelegate`), modify the `start` method to include the custom host parameters if needed.

```swift
import Applivery

let applivery = AppliverySDK.shared
applivery.start(token: appToken, tenant: "YOUR_TENANT")
```

#### Parameters:

- **`token`**: Your Applivery APP token (required).
- **`tenant`**: Your Applivery tenant ID (optional).  
  If you do not specify a value for the `tenant` parameter, the SDK will use the default Applivery host.

Below is an updated README section including instructions on how to configure a custom host and handle redirect URLs within your iOS app using the Applivery SDK.

# Handling SAML Redirect URLs

When integrating SAML authentication, your app may receive a redirect URL once the user completes the authentication with the SAML Identity Provider. The Applivery SDK provides a method to handle this redirect and proceed with the authentication flow.

## Step 1: Configure the URL Scheme

1. Open your app's `Info` section > URL Types.
2. Add a new `URL Type` entry.
3. Set the **URL Schemes** field to the scheme your SAML provider uses to redirect back to your app with `applivery-(your bundle id replacing the dots by dashes)` in `URL Schemes` field.
e.g if the bundle of your app is `com.example.myAwesomeApp` the url type would be: `applivery-com-example-myAwesomeApp`

## Step 2: Handling the Redirect URL in AppDelegate (iOS 12 and earlier, or if Scenes are not used)

Implement the following method in your `AppDelegate`:

```swift
func application(_ app: UIApplication,
                 open url: URL,
                 options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    // Pass the URL to the Applivery SDK handler
    AppliverySDK.shared.handleRedirectURL(url: url)
    return true
}
```

## Step 3: Handling the Redirect URL in SceneDelegate (iOS 13+)

If your project uses SceneDelegate, you should implement the URL handling here:

```swift
func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    guard let url = URLContexts.first?.url else { return }
    // Pass the URL to the Applivery SDK handler
    AppliverySDK.shared.handleRedirectURL(url: url)
}
```

## Custom Log Handler

In addition to controlling the verbosity via `logLevel`, you can capture Applivery SDK logs by providing a custom log handler. This allows you to integrate the logs into your own logging system or send them to a remote server for analysis.

### Swift

```swift
import Applivery

// ...

// Somewhere early in the app's lifecycle, e.g., AppDelegate or SceneDelegate
let applivery = AppliverySDK.shared

// Set a custom log handler
applivery.setLogHandler { message, level, filename, line, funcname in
    // You can filter logs by level or reformat them
    if level <= LogLevel.info.rawValue {
        print("[Applivery INFO] - \(message)")
    } else {
        print("[Applivery ERROR] - \(message)")
    }
}

// Optionally set the logLevel to print more or less data
applivery.logLevel = .info
```

### Objective-C

```objc
@import Applivery;

// ...

AppliverySDK *applivery = [AppliverySDK shared];

// Set a custom log handler
[applivery setLogHandler:^(NSString * _Nonnull message,
                           NSInteger level,
                           NSString * _Nonnull filename,
                           NSInteger line,
                           NSString * _Nonnull funcname) {
    // For example, only display log messages that are .info or below
    if (level <= LogLevelInfo) {
        NSLog(@"[Applivery INFO] - %@", message);
    } else {
        NSLog(@"[Applivery ERROR] - %@", message);
    }
}];

// Optionally set the logLevel to print more or less data
applivery.logLevel = LogLevelInfo;
```

### Log Handler Parameters

- **`message`**: The actual log message from the SDK.
- **`level`**: The log level as an integer. Compare against `LogLevel` enum values to filter or handle logs differently.
- **`filename`**: The name of the file where the log message originated (for debugging).
- **`line`**: The line number in the file where the log message originated (for debugging).
- **`funcname`**: The function name from which the log message was sent (for debugging).

You can implement any desired behavior within this handler, such as sending logs to a remote logging service, filtering them by level, or integrating them with an existing logging framework.

## 🔧 `AppliveryConfiguration`

The `AppliveryConfiguration` object allows you to customize the behavior of the SDK at runtime, such as authentication enforcement or delaying update prompts.

### 🧩 Initialization in Swift

```swift
import Applivery

let config = AppliveryConfiguration(
    postponedTimeFrames: [60, 300, 600], // Delays in seconds before retrying update prompts
    enforceAuthentication: true          // Require user authentication before SDK usage
)
```

### 🧩 Initialization in Objective-C

If you're using Objective-C, you must use the dedicated `NSNumber`-based initializer:

```objc
#import <Applivery/Applivery-Swift.h>

NSArray<NSNumber *> *timeFrames = @[@60, @300, @600];
AppliveryConfiguration *config = [[AppliveryConfiguration alloc] initWithPostponedTimeFramesNSNumber:timeFrames
                                                                              enforceAuthentication:YES];
```

### 🛠 Available Properties

| Property                | Type             | Description                                                                |
|-------------------------|------------------|----------------------------------------------------------------------------|
| `postponedTimeFrames`   | `[TimeInterval]` | List of time intervals (in seconds) to delay update prompts               |
| `enforceAuthentication` | `Bool`           | Whether the SDK should enforce user authentication before proceeding      |

> **Note:** When using Objective-C, the initializer is named `initWithPostponedTimeFramesNSNumber:enforceAuthentication:` to avoid conflicts with the Swift-native initializer.

### 🧪 Default Configuration

If no configuration is provided, the SDK will use the default one:

```swift
let defaultConfig = AppliveryConfiguration()
```

You can also use the static `empty` property:

```swift
let config = AppliveryConfiguration.empty
```
