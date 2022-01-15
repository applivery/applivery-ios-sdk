![Applivery Logo](https://www.applivery.com/wp-content/uploads/2019/06/applivery-og.png)

![Version](https://img.shields.io/badge/version-3.2.3-blue.svg)
![Language](https://img.shields.io/badge/Language-Swift-orange.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Applivery.svg)](https://cocoapods.org/pods/Applivery)
[![Fastlane Plugin](https://img.shields.io/badge/Fastlane_Plugin-available-brightgreen.svg)](https://github.com/fastlane-community/fastlane-plugin-applivery)
[![Twitter](https://img.shields.io/badge/twitter-@Applivery-blue.svg?style=flat)](https://twitter.com/Applivery)

### Quality checks

[![Swift](https://github.com/applivery/applivery-ios-sdk/actions/workflows/swift.yml/badge.svg?branch=master)](https://github.com/applivery/applivery-ios-sdk/actions/workflows/swift.yml)
[![codecov](https://codecov.io/gh/applivery/applivery-ios-sdk/branch/develop/graph/badge.svg)](https://codecov.io/gh/applivery/applivery-ios-sdk)
[![codebeat badge](https://codebeat.co/badges/c5895172-0986-4905-8e6f-38dccb63a059)](https://codebeat.co/projects/github-com-applivery-applivery-ios-sdk-master)
[![BCH compliance](https://bettercodehub.com/edge/badge/applivery/applivery-ios-sdk)](https://bettercodehub.com/)

### Table of Contents

* [Overview](#overview)
* [Getting Started](#getting-started)
* [SDK Installation](#sdk-installation)
  * [Using SwiftPM](#using-swift-package-manager)
  * [Using Carthage](#using-carthage)
  * [Using CocoaPods](#using-cocoapods)
  * [Manual installation](#manual-installation)
  * [Objective-C](#objective-c)
* [SDK Setup](#sdk-setup)
  * [Swift](#swift)
  * [Objective-C](#objective-c-1)
  * [About params](#about-params)
* [Swift & Xcode versions support](#swift--xcode-version-support)
* [Advanced concepts](#advanced-concepts)

# Overview

Applivery iOS SDK is a Framework to support [Applivery.com Mobile App distribution](http://www.applivery.io) for iOS Apps.

With Applivery you can massively distribute your iOS Apps (both Ad-hoc or In-House/Enterprise) through a customizable distribution site with no need of your users have to be registered in the platform. Combined with [Apple Developer Enterprise Program](https://developer.apple.com/programs/enterprise/) and Enterprise certificates, Applivery is perfect not only for beta testing distribute to your QA team, but also for In-House Enterprise distribution for beta testing users, prior to a release, or even for corporative Apps to the employees of a company.

## Features

* **Automatic OTA Updates** when uploading new versions to Applivery.
* **Force update** if App version is lower than the minimum version configured in Applivery.
* **Send feedback**. Your test users can report a bug or send improvements feedback by simply taking a screenshot.
* **Employee authentication**. You can login yours employees in order to track analytics of installations, block app usage, to know who sent a feedback or report, etc..

# Getting Started

First of all, you should create an account on [Applivery.io](https://dashboard.applivery.io) and then add a new Application.

## Get your credentials

**API TOKEN**: that identifies and grants access to your account in order to use the SDK.

You can get your API TOKEN in your `App -> Settings -> API Auth` section.

## SDK Installation

### Using Swift Package Manager

(**RECOMMENDED**)

In the Xcode menu, you just need to open “File -> Add Packages...” and enter the Github url: https://github.com/applivery/applivery-ios-sdk.git

then we recommend to configure the dependency rule as "Up to next major version" (3.3.0 < 4.0.0).

At this point, you should choose **one** of the following sdk versions:

* Applivery 
* AppliveryDynamic

Select `Applivery` if your app is for internal use only. For example, an in-house business app for your employees (your not going to upload it to the Appstore). This is a static version of the library.

**Publish an app with the Applivery SDK in the Appstore is forbidden** and your build may be rejected at review process. You should manually delete Applivery each time you upload to the Appstore, or you can use the AppliveryDynamic framework and excluding it at build time.

--- 
### Dynamically exclude Applivery SDK for Appstore schemes

Select `AppliveryDynamic` if you are using Applivery for internal beta testing and eventually you are going to upload a build to the Appstore. With this dynamic framework version, you could dynamically exclude applivery when compiling a build for the Appstore. 

### Step 1 

First add the framework with "Embbed & Sign" flag and be sure that is included in "Build Phases" -> "Embed Frameworks"

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
    let applivery = Applivery.shared
    applivery.logLevel = .info
    applivery.start(token: APPLIVERY_TOKEN, appStoreRelease: false)
#endif
	}

}
```

The lines between the `#if` macros will not compile (as they wouldn't exists) if you are compiling for a build configuration that has those `Swift Compiler - Custom Flags` (you can add/edit them in the Build settings)


You can find a tutorial about dinamicaly exclude Applivery for an Appstore scheme [here](https://www.applivery.com/docs/troubleshooting/exclude-applivery-ios-sdk/)


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

``` swift
import Applivery
```

and then the magic:

``` swift
let applivery = Applivery.shared
applivery.start(token: "YOUR_TOKEN", appStoreRelease: false)
```

### Objective-C

The import:

```objc
@import Applivery;
```

The magic:

``` objc
Applivery *applivery = [Applivery shared];
[applivery startWithToken:@"YOUR_TOKEN" appStoreRelease:NO];
```

**IMPORTANT I:** As you can suspect, you should replace the string `YOUR_TOKEN` with your token. Easy! Don't you think so?

**IMPORTANT II:** If you are experimenting problems submitting your app to the AppStore, please check this known issue about [Embedded Frameworks and AppStore submissions](https://github.com/applivery/applivery-ios-sdk#embedded-frameworks-and-appstore-submissions)

### About params

* **token**: Your app token
* **appStoreRelease**: (DEPRECATED - You should not upload a build with Applivery to the Appstore)

## Swift & Xcode version support

The compatibility version is as follow:

| Applivery Version | Xcode Version  | Swift Version |
|-------------------|----------------|---------------|
| **v1.2.x**        | 7.x            | 2.0, 2.1, 2.2 |
| **v1.3.x**        | 8.x            | 2.3           |
| **v2.x**          | 8.x, 9.x       | 3.0, 3.1, 4.0 |
| **v2.7.x**        | 9.x, 10.x      | 4.0, 4.2      |
| **v3.0**          | 10.x, 11.x     | 4.0, 4.2, 5.0 |
| **v3.1**          | 11.x           | 4.0, 4.2, 5.x |
| **v3.2**          | 12.x           | 5.x           |
| **v3.3**           | 13.x           | 5.X           |

# Advanced concepts

## Logs and debugging

In some cases you'll find usefull to see what is happening inside Applivery SDK. If so, you can enable logs for debugging purposes.

### Swift

``` swift
applivery.logLevel = .info
```

### Objective-C

``` objc
applivery.logLevel = LogLevelInfo;
```

Possible values are:

* **None**: Default value. No logs will be shown. Recommended for production environments.
* **Error**: Only warnings and errors. Recommended for develop environments.
* **Info**: Errors and relevant information. Recommended for test integrating Applivery.
* **Debug**: Request and Responses to Applivery's server will be displayed. Not recommended to use, only for debugging Applivery.

## Disable feedback

By default, Applivery will show a feedback formulary to your users when a screenshot is detected. If you want to avoid this, you can disable it calling the following method:

### Swift

``` swift
applivery.disableFeedback()
```

### Objective-C

``` objc
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

```swift
applivery.update(
    onSuccess: { (...) }  // Handle here any action you must perform on success
    onError: { errorString in (...) } // Handle here the error case. A string whith the reason is passed to this callback
)
```
Use this method to download and install the newest build available.

## Customize SDK's colors

You can create a new instance of `Palette` class and assign it to `Applivery.shared.palette`

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

### Colors you can change

* `primaryColor`: Main color of your brand
* `secondaryColor`: Background color
* `primaryFontColor`: Primary font color. It should be in contrast with the primary color
* `secondaryFontColor`: Secondary font color. It should be in contrast with the secondary color
* `screenshotBrushColor`: In the feedback's view, users can edit the screenshot to draw lines on top of it. By default, these lines are red, but you are allowed to change the color to fit better with your application's color palette.

## Customize string literals

You can customize the SDK string literals to fit your app. 

### Examples

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

_**Important**_: The default literals are only in english. Consider to set localized strings to fully support all languages your app does.

## Embedded frameworks & ipa generation

If you have installed the SDK with Carthage and as a Dynamic framework, Applivery.framework is built as a fat universal library, that means that you can compile for devices or simulator without any problem, but you can not make an ipa file if it has inside an embedded framework with simulator slices.

 In this case, the solution is as simple as add [this script](https://github.com/applivery/applivery-ios-sdk/blob/master/script/applivery_script.sh) in "New Run Script Phase".
 You'll find inside _Build Phases_ tab.
