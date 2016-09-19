# Applivery iOS SDK
![Version](https://img.shields.io/badge/version-1.3-blue.svg)
![Language](https://img.shields.io/badge/Language-Swift-orange.svg)
[![Build Status](https://travis-ci.org/applivery/applivery-ios-sdk.svg?branch=master)](https://travis-ci.org/applivery/applivery-ios-sdk)

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Fastlane Plugin](https://img.shields.io/badge/Fastlane_Plugin-available-brightgreen.svg)](https://github.com/applivery/fastlane-applivery-plugin)

<!--
[![Coverage Status](https://coveralls.io/repos/github/applivery/applivery-ios-sdk/badge.svg?branch=master)](https://coveralls.io/github/applivery/applivery-ios-sdk?branch=master)
-->

Framework to support [Applivery.com Mobile App distribution](http://www.applivery.com) for iOS Apps.

## Overview

With Applivery you can massively distribute your iOS Apps (both Ad-hoc or In-House/Enterprise) through a customizable distribution site with no need of your users have to be registered in the platform. Combined with [Apple Developer Enterprise Program](https://developer.apple.com/programs/enterprise/) and Enterprise certificates, Applivery is perfect not only for beta testing distribute to your QA team, but also for In-House Enterprise distribution for beta testing users, prior to a release, or even for corporative Apps to the employees of a company.

**Features:**
* **Automatic OTA Updates** when uploading new versions to Applivery.
* **Force update** if App version is lower than the minimum version configured in Applivery.

## Getting Started

First of all, you should create an account on [Applivery.com](https://dashboard.applivery.com/register) and then add a new Application.


### Get your credentials

**ACCOUNT API KEY**: that identifies and grants access to your account in order to use the [Applivery API](http://www.applivery.com/developers/api/). The API will aallow you to easily create an script to integrate your CI system with Applivery, but also is needed for this SDK.

You can get your ACCOUNT API KEY in the `Developers` section (left side menu).

![Developers section](https://github.com/applivery/applivery-ios-sdk/blob/master/documentation/developers_section.png)

**APP ID**: Is your application identifier. You can find it in the App details, going to `Applications` -> Click desired App -> (i) Box

![APP ID](https://github.com/applivery/applivery-ios-sdk/blob/master/documentation/application_id.png)

## SDK Installation

### iOS 8 and later

#### Using Carthage
Add the following line to your's Cartfile

```
github "applivery/applivery-ios-sdk" ~> 1.3
```
and then run `carthage update`. More info about Carthage [here](https://github.com/Carthage/Carthage#installing-carthage).

*Note*: If you need to compile your app using XCode 7, you should use v1.2 version.

#### Or you can try manually

1. Download the Applivery.framework [here](https://github.com/applivery/applivery-ios-sdk/releases)
1. Drag it to your frameworks folder
1. Add it to the embedded binaries

![Embbeded binaries](https://github.com/applivery/applivery-ios-sdk/blob/master/documentation/embbeded_binaries.png)


#### Objective-C

If your project is written in Objective-C, you should also enable the "_Embedded Content Contains Swift Code_" option. You'll find it in the _Build Settings_ section:

![Embedded binaries](https://github.com/applivery/applivery-ios-sdk/blob/master/documentation/embedded_content.png)


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



### Embedded frameworks and AppStore submissions

Applivery.framework is built with a fat universal library, this means that you can compile for devices or simulator without any problem, but due to a possible (and strange) [Apple's bug](http://www.openradar.me/19209161), you can not submit an App to the AppStore if it has inside an embedded framework with simulator slices.

Depends of yours method integration, the solution is:

1. **If you are using Carthage**. 

	Remember to run the `copy-frameworks` as described [here](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos) in the step 4.
1. **If you added Applivery manually**.
 
	In this case, the solution is as simple as add [this script](https://github.com/applivery/applivery-ios-sdk/blob/master/script/applivery_script.sh) in "New Run Script Phase". 
	You'll find inside _Build Phases_ tab.

	![Applivery script](https://github.com/applivery/applivery-ios-sdk/blob/master/documentation/applivery_script.png)

	Please note that you should edit the `APPLIVERY_FRAMEWORK_PATH` specifing where the framework is, inside your project path.

	This script is based on the [solution that Carthage](https://github.com/Carthage/Carthage/issues/188) found (thank guys!)

