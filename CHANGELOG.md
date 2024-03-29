# Change Log

## [v3.3](https://github.com/applivery/applivery-ios-sdk/releases/tag/v3.3)

### New

* Add `AppliveryDynamic` product version to SwiftPM integration. With this versión you can dinamically exclude Applivery when compiling a build for the Appstore. See the [README](https://github.com/applivery/applivery-ios-sdk#using-swift-package-manager) for more information
* Removed the `appStoreRelease` flag since uploading a build with Applivery to the Appstore is forbidden.

### Fix

* Feedback fails detecting if user is over wifi in the latest iOS version
* Updated iOS devices list for your analytics.

---

## [v3.2.3](https://github.com/applivery/applivery-ios-sdk/releases/tag/v3.2.3)

### Fix

* Workaround to fix Xcode bug while loading storyboards with Swift Package Manager

---

## [v3.2.2](https://github.com/applivery/applivery-ios-sdk/releases/tag/v3.2.2)

### Fix

* Error when trying to update while integrating applivery with swift package manager

---

## [v3.2](https://github.com/applivery/applivery-ios-sdk/releases/tag/v3.2)

### New

* Swift Package Manager support (#25)
* Improved feedback when downloads limits are reached (#33)
* Installation identificacion (#36)

---

## [v3.1.3](https://github.com/applivery/applivery-ios-sdk/releases/tag/v3.1.3)

### Fixed

* Conflict with localization file using cocoapods as a static framework (#34). Thanks to @RafaelFernandezAlv

---

## [v3.1.1](https://github.com/applivery/applivery-ios-sdk/releases/tag/v3.1.1)

### Fixed

* SDK is available with CocoaPods again (#32)
* Fixed custom login (bind user) error if empty tags are setted (#26)
* Segmented control in Feedback View is not using the palette defined colors with iOS 13 (#30)

---

## [v3.1](https://github.com/applivery/applivery-ios-sdk/releases/tag/v3.1)

### New

* Public method `update()` to programmatically download and install the latest version (#22)
* Public method `isUpToDate()` to check if application is updated to the latest version available (#21)
* OS, device and package information is sent to Applivery, so this information can be used in planned features of the dashboard (#20)

### Fixed

* Force update view is dismissable in iOS 13
* Alerts changes their position when feedback view is presented

### Improvements

* Handle error 5004 (SDK not allowed) and give this feedback to the developer (#19)

---

## [v3.0](https://github.com/applivery/applivery-ios-sdk/releases/tag/v3.0)

### New

* SDK works with the new Applivery's API. (www.applivery.io)
* Support for custom login using `bindUser()` function.

---

## [v2.7.2](https://github.com/applivery/applivery-ios-sdk/releases/tag/v2.7.2)

### Fixed

* All the public methods and params are now available for Obj-C

---

## [v2.7.1](https://github.com/applivery/applivery-ios-sdk/releases/tag/v2.7.1)

### Fixed

* Applivery could crash with some project settings running in the simulator. Thanks to @pabloviciano

---

## [v2.7](https://github.com/applivery/applivery-ios-sdk/releases/tag/v2.7)

### New

* iPhone X screens adaptations (#15)
* Swift 4 adaptations (#16)
* MIT Licence (#14)
* Public method to trigger feedback view programmatically (#13)
* SDK Version displayed in console logs

### Fixed

* Landscape feedbacks

---

## [v2.6.1](https://github.com/applivery/applivery-ios-sdk/releases/tag/v2.6.1)

### Fixed

* Race condition when checking if app is ready to present the update views (Fixes #8). Thanks to @SPopenko

---

## [v2.6](https://github.com/applivery/applivery-ios-sdk/releases/tag/v2.6)

### New

* Display Applivery User Authentication before installing new versions (#2)
* Display Authentication before sending feedback/bug Reports (#3)

---

## [v2.5.1](https://github.com/applivery/applivery-ios-sdk/releases/tag/v2.5.1)

### Fixed

* Disable code coverage because iTunes rejects binaries with coverage enabled (Fixes #7). Thanks to @stantoncbradley

---

## [v2.5](https://github.com/applivery/applivery-ios-sdk/releases/tag/v2.5)

### New

* XCode 9 & Swift 4 compatibility

---

## [v2.4.1](https://github.com/applivery/applivery-ios-sdk/releases/tag/v2.4.1)

### Fixed

* Force update crash when Applivery is installed with CocoaPods

---

## [v2.4](https://github.com/applivery/applivery-ios-sdk/releases/tag/v2.4)

### New

* Developers can customize the SDK's color palette to fit their app design
* Developers can customize the SDK's string literals
* Agnostic design: removed Applivery's fonts & logo

### Improvements

* Better code documentation

---

## [v2.3](https://github.com/applivery/applivery-ios-sdk/releases/tag/v2.3)

### New

* Applivery iOS SDK can now be installed with CocoaPods

---

## [v2.2.4](https://github.com/applivery/applivery-ios-sdk/releases/tag/v2.2.4)

### Fixed

* Swiftlint errors while building the framework using carthage

---

## [v2.2.3](https://github.com/applivery/applivery-ios-sdk/releases/tag/v2.2.3)

### Fixed

* Force update modal view was preventing from showing

---

## [v2.2](https://github.com/applivery/applivery-ios-sdk/releases/tag/v2.2)

### New

* Users can draw lines in the screenshots to highlight bugs before sending the report
* Users can shake while drawing to clean the screen.

### Improvement

* Added smooth transitions and animations.

---

## [v2.1](https://github.com/applivery/applivery-ios-sdk/releases/tag/v2.1)

### New

* Added device info to feedback & bug reports

### Improvement

* Bugfixes & stability improvements

---

## [v2.0](https://github.com/applivery/applivery-ios-sdk/releases/tag/v2.0)

### New

* Swift 3 support

---

## [v1.3](https://github.com/applivery/applivery-ios-sdk/releases/tag/v1.3)

### New

* XCode 8 & Swift 2.3 compatibility

### Fixed

* An error message appeared when trying to download new build version.

---

## [v1.2](https://github.com/applivery/applivery-ios-sdk/releases/tag/v1.2)

### New

* Added a method to disable feedback formulary

---

## [v1.1.1](https://github.com/applivery/applivery-ios-sdk/releases/tag/v1.1.1)

### Improved

* Better logs

---

## [v1.1](https://github.com/applivery/applivery-ios-sdk/releases/tag/v1.1)

### New

* Feedback and bug reporting

---

## [v1.0.2](https://github.com/applivery/applivery-ios-sdk/releases/tag/v1.0.2)

### New

* Added support for XCode 7.3 and Swift 2.2

### Fixed

* In some scenarios, the app freeze due to an Apple's bug while registering SDK's fonts.

---

## [v1.0.1](https://github.com/applivery/applivery-ios-sdk/releases/tag/v1.0.1)

### Improvement

* If the build url can not start, an error message is prompt to the user

### Fixed

* Applivery didn't start if a minimun version (for must update option) was not setted

---

## [v1.0](https://github.com/applivery/applivery-ios-sdk/releases/tag/v1.0)

This is the first Applivery's SDK version.

The core features are:

* Force update Message
* OTA update Message
* Download & Install new build (through force update or OTA update messages)

---
