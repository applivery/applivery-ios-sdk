![Applivery Logo](https://www.applivery.com/img/icons/applivery-header-1200x627px.png)

![Version](https://img.shields.io/badge/version-2.3-blue.svg)
![Language](https://img.shields.io/badge/Language-Swift-orange.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Applivery.svg)](https://cocoapods.org/pods/Applivery)
[![Fastlane Plugin](https://img.shields.io/badge/Fastlane_Plugin-available-brightgreen.svg)](https://github.com/applivery/fastlane-applivery-plugin)
[![Twitter](https://img.shields.io/badge/twitter-@Applivery-blue.svg?style=flat)](https://twitter.com/Applivery)

### Quality checks

[![Build Status](https://travis-ci.org/applivery/applivery-ios-sdk.svg?branch=master)](https://travis-ci.org/applivery/applivery-ios-sdk)
[![codecov](https://codecov.io/gh/applivery/applivery-ios-sdk/branch/master/graph/badge.svg)](https://codecov.io/gh/applivery/applivery-ios-sdk)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/d9f8d737904b4785b846afec3df3e26c)](https://www.codacy.com/app/a-j-agudo/applivery-ios-sdk?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=applivery/applivery-ios-sdk&amp;utm_campaign=Badge_Grade)



## Overview

Applivery iOS SDK is a Framework to support [Applivery.com Mobile App distribution](http://www.applivery.com) for iOS Apps.

With Applivery you can massively distribute your iOS Apps (both Ad-hoc or In-House/Enterprise) through a customizable distribution site with no need of your users have to be registered in the platform. Combined with [Apple Developer Enterprise Program](https://developer.apple.com/programs/enterprise/) and Enterprise certificates, Applivery is perfect not only for beta testing distribute to your QA team, but also for In-House Enterprise distribution for beta testing users, prior to a release, or even for corporative Apps to the employees of a company.

**Features:**
* **Automatic OTA Updates** when uploading new versions to Applivery.
* **Force update** if App version is lower than the minimum version configured in Applivery.

## Getting Started

First of all, you should create an account on [Applivery.com](https://dashboard.applivery.com/register) and then add a new Application.


### Get your credentials

**SDK API KEY**: that identifies and grants access to your account in order to use the SDK.

You can get your SDK API KEY in the `Developers` section (left side menu).

![Developers section](https://raw.githubusercontent.com/applivery/applivery-ios-sdk/master/documentation/developers_section.png)

**APP ID**: Is your application identifier. You can find it in the App details, going to `Applications` -> Click desired App -> (i) Box

![APP ID](https://raw.githubusercontent.com/applivery/applivery-ios-sdk/master/documentation/application_id.png)

## SDK Installation

### iOS 8 and later

#### Using Carthage

Install carthage with using brew

```bash
$ brew update && brew install carthage
```

Add the following line to your's Cartfile

```
github "applivery/applivery-ios-sdk" ~> 2.3
```
Run `carthage update` and then drag the built framework into your project. 

More info about Carthage [here](https://github.com/Carthage/Carthage#installing-carthage).


#### Using CocoaPods

Install the ruby gem

```bash
$ gem install cocoapods
```

Add the following line to your's Podfile

```ruby
project '<Your Project Name>.xcodeproj'

# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
use_frameworks!
target '<Your Target Name>' do
  pod 'Applivery', '~> 2.3'
end
```
and then run `pod install`. More info about CocoaPods [here](https://cocoapods.org)


#### Or you can try manually

1. Download the Applivery.framework [here](https://github.com/applivery/applivery-ios-sdk/releases)
1. Drag it to your frameworks folder
1. Add it to the embedded binaries

![Embbeded binaries](https://raw.githubusercontent.com/applivery/applivery-ios-sdk/master/documentation/embbeded_binaries.png)


#### Objective-C

If your project is written in Objective-C, you should also enable the "_Always Embed Swift Standard Libraries_" option. You'll find it in the _Build Settings_ section:

![Embedded binaries](https://raw.githubusercontent.com/applivery/applivery-ios-sdk/master/documentation/embedded_content.png)


### Swift & XCode version support

The compatibility version is as follow:

| Applivery Version | Xcode Version  | Swift Version |
|-------------------|----------------|---------------|
| **v1.2.x**        | 7.x            | 2.0, 2.1, 2.2 |
| **v1.3.x**        | 8.x            | 2.3           |
| **v2.x**          | 8.x            | 3.0           |


### Ok! Let's go!

At your application start up (for example in the _AppDelegate_) add the following code:

#### Swift

First import the module:

``` swift
import Applivery
```

and then the magic:

``` swift
let applivery = Applivery.sharedInstance
applivery.start(apiKey: "YOUR_API_KEY", appId: "YOUR_APP_ID", appStoreRelease: false)
```


#### Objective-C

The import:

```objc
@import Applivery;
```

The magic:

``` objc
Applivery *applivery = [Applivery sharedInstance];
[applivery startWithApiKey:@"YOUR_API_KEY" appId:@"YOUR_APP_ID" appStoreRelease:NO];
```

**IMPORTANT I:** As you can suspect, you should replace the strings `YOUR_API_KEY` and `YOUR_APP_ID` with you api key and your app id respectively. Easy! Don't you think so?

**IMPORTANT II:** If you are experimenting problems submitting your app to the AppStore, please check this known issue about [Embedded Frameworks and AppStore submissions](https://github.com/applivery/applivery-ios-sdk#embedded-frameworks-and-appstore-submissions)


## About params

- **apiKey**: Your developer's Api Key
- **appId**: Your application's ID
- **appStoreRelease**: Flag to mark that the build will be submitted to the AppStore. This is needed to prevent unwanted behavior like prompt to a final user that a new version is available on Applivery.com.
	* True: Applivery SDK will not trigger automatic updates anymore. **Use this for AppStore**
	* False: Applivery SDK will normally. Use this with builds distributed through Applivery.

## Advanced concepts


### Logs and debugging

In some cases you'll find usefull to see what is happening inside Applivery SDK. If so, you can enable logs for debugging purposes.

**Swift**

``` swift
applivery.logLevel = .Info
```

**Objective-C**

``` objc
applivery.logLevel = LogLevelInfo;
```

Possible values are:
	
- **None**: Default value. No logs will be shown. Recommended for production environments.
- **Error**: Only warnings and errors. Recommended for develop environments.
- **Info**: Errors and relevant information. Recommended for test integrating Applivery.
- **Debug**: Request and Responses to Applivery's server will be displayed. Not recommended to use, only for debugging Applivery.

### Disable feedback

By default, Applivery will show a feedback formulary to your users when a screenshot is detected. If you want to avoid this, you can disable it calling the following method:

**Swift**

``` swift
applivery.disableFeedback()
```

**Objective-C**

``` objc
[applivery disableFeedback];
```

### Change feedback's brush color

In the feedback's view, users can edit the screenshot to draw lines on top of it. By default, these lines are red, but you are allowed to change the color to fit better with your application's color palette.

**Swift**

``` swift
applivery.screenshotBrushColor = .blue
```

**Objective-C**

``` objc
applivery.screenshotBrushColor = [UIColor blueColor];
```


### Embedded frameworks and AppStore submissions

Applivery.framework is built with a fat universal library, this means that you can compile for devices or simulator without any problem, but due to a possible (and strange) [Apple's bug](http://www.openradar.me/19209161), you can not submit an App to the AppStore if it has inside an embedded framework with simulator slices.

Depends of your integration method, the solution is:

1. **If you are using Carthage**. 

	Remember to run the `copy-frameworks` as described [here](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos) in the step 4.
1. **If you added Applivery manually**.
 
	In this case, the solution is as simple as add [this script](https://github.com/applivery/applivery-ios-sdk/blob/master/script/applivery_script.sh) in "New Run Script Phase". 
	You'll find inside _Build Phases_ tab.

	![Applivery script](https://github.com/applivery/applivery-ios-sdk/blob/master/documentation/applivery_script.png)

	Please note that you should edit the `APPLIVERY_FRAMEWORK_PATH` specifing where the framework is, inside your project path.

	This script is based on the [solution that Carthage](https://github.com/Carthage/Carthage/issues/188) found (thank guys!)

