#!/bin/bash
set -xeuo pipefail

# Cleanup previous build outputs
rm -rf xcframeworks
rm -rf DerivedData

# COMMON BUILD SETTINGS
# ---------------------
# SWIFT_ENABLE_BACKDEPLOYMENT_CONCURRENCY=YES
#   Ensures concurrency symbols are included for iOS 13/14 (if you use async/await).
# SWIFT_STRIP_SYMBOLS=NO
#   Prevents stripping Swift symbols that Concurrency might need.
# STRIP_STYLE="non-global"
#   Tells the build system how to strip (you've kept it).
# MACH_O_TYPE=staticlib
#   Creates a static .framework. Typically, dynamic frameworks are more common if
#   you need the Swift runtime embedded. But if you truly need a static framework,
#   be sure the app that uses it also embeds Swift libraries if it's ObjC-only.

COMMON_BUILD_SETTINGS=(
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES
  GCC_GENERATE_DEBUGGING_SYMBOLS=NO
  CLANG_ENABLE_MODULE_DEBUGGING=NO
  STRIP_STYLE=non-global
  IPHONEOS_DEPLOYMENT_TARGET=13.0
  SWIFT_ENABLE_BACKDEPLOYMENT_CONCURRENCY=YES
  SWIFT_STRIP_SYMBOLS=NO
)

# Build .framework for iOS Device
xcodebuild build \
  -project AppliverySDK.xcodeproj \
  -scheme Applivery \
  -configuration Release \
  MACH_O_TYPE=staticlib \
  "${COMMON_BUILD_SETTINGS[@]}" \
  -destination "generic/platform=iOS" \
  -derivedDataPath DerivedData/Device

# Build .framework for iOS Simulator
xcodebuild build \
  -project AppliverySDK.xcodeproj \
  -scheme Applivery \
  -configuration Release \
  MACH_O_TYPE=staticlib \
  "${COMMON_BUILD_SETTINGS[@]}" \
  -destination "generic/platform=iOS Simulator" \
  -derivedDataPath DerivedData/Simulator

# Combine the frameworks into an XCFramework
xcodebuild -create-xcframework \
  -framework DerivedData/Device/Build/Products/Release-iphoneos/Applivery.framework \
  -framework DerivedData/Simulator/Build/Products/Release-iphonesimulator/Applivery.framework \
  -output xcframeworks/Applivery.xcframework
