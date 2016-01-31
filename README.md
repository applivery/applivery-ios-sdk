# Applivery iOS SDK

Framework to support [Applivery's distribution system](http://www.applivery.com) in iOS platform

## Overview

With Applivery you can massively distribute your iOS ipa builds, Ad-hoc or In-House (Enterprise), through a customizable distribution site with no need of your users have to be registered in the platform. In combination with an Enterprise account, Applivery is perfect not only to distribute your beta builds to your QA team, but also you can share with a massive beta testing users prior to a release or even for the participants of an event that your company is planning to.


## Getting Started

First of all, you should create an account on [Applivery's platform](https://dashboard.applivery.com/invitation) and then add a new application.


### Get yours credentials

_API KEY_: The api key is your developer's identifier in order to use the [Applivery's API](http://www.applivery.com/developers/api/). With the api you could, for example, made and script to integrate your CI system with applivery, but also is needed for this SDK.

You can get it in the "Developers" section:

![Developers section](https://github.com/applivery/applivery-ios-sdk/blob/master/documentation/developers_section.png)

_App ID_: Is your application identifier. You can get it

![Application ID](https://github.com/applivery/applivery-ios-sdk/blob/master/documentation/application_id.png)

### SDK Installation

### iOS 7

The framework is a dynamic embedded framework made it with Swift, so it will only works with iOS 8 or later projects. But don't worry, you can use directly the code (is **open source**!) and will works. 

The easiest way is to import like a subproject inside yours.


### iOS 8 and later

Download the Applivery.framework and drag it to your frameworks folder.


#### Embbeded binaries

Be sure that is added in embedded binaries:

![Embbeded binaries](https://github.com/applivery/applivery-ios-sdk/blob/master/documentation/embbeded_binaries.png)


#### Objective-C

If your project is build with Objective-C, you should also enable the "Embedded Content Contains Swift Code" option in the Build Settings section:

![Embedded binaries](https://github.com/applivery/applivery-ios-sdk/blob/master/documentation/embedded_content.png)

#### Applivery Script

Applivery.framework is built with a fat universal library, this means that you can compile for devices or simulator without problem, but due to a possible (and strange) [Apple's bug](http://www.openradar.me/19209161), you can not submit an app to the Appstore if it has inside an embedded framework with simulator slices.

So, the solution for this is to add the content of [this script](https://github.com/applivery/applivery-ios-sdk/blob/master/script/applivery_script.sh) in a "New Run Script Phase" in Build Phases:

![Applivery script](https://github.com/applivery/applivery-ios-sdk/blob/master/documentation/applivery_script.png)

This script is based on the [solution that Carthago](https://github.com/Carthage/Carthage/issues/188) found (thank guys!)



### Ok ok! Put the SDK to work!

At your application start up (for example in the AppDelegate) add the following code:

#### Swift

First import the module:

``` swift
import Applivery
```

and then the magic:

``` swift
let applivery = Applivery.sharedInstance
applivery.logLevel = .Info
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
applivery.logLevel = LogLevelInfo;
[applivery startWithApiKey:@"YOUR_API_KEY" appId:@"YOUR_APP_ID" appStoreRelease:NO];
```

**IMPORTANT**: As you can suspect, you should replace the strings `YOUR_API_KEY` and `YOUR_APP_ID` with you api key and your app id respectively. Easy! don't you?


## About params

### LogLevel property

Type of Applivery's logs you want displayed in the debug console
	
- **None**: No log will be shown. Recommended for production environments.
- **Error**: Only warnings and errors. Recommended for develop environments.
- **Info**: Errors and relevant information. Recommended for test integrating Applivery.
- **Debug**: Request and Responses to Applivery's server will be displayed. Not recommended to use, only for debugging Applivery.

### Start method

- **apiKey**: Your developer's Api Key
- **appId**: Your application's ID
- **appStoreRelease**: Flag to mark the build as a build that will be submitted to the AppStore. This is needed to prevent unwanted behavior like prompt to a final user that a new version is available on Applivery.
	* True: Applivery will stop any activity. **Use this for AppStore**
	* False: Applivery will works as normally. Use this with distributed builds in Applivery.

