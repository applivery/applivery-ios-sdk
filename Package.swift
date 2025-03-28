// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "Applivery",
	defaultLocalization: "en",
	platforms: [
        .iOS("13.0")
	],
	products: [
		.library(name: "Applivery", targets: ["Applivery"]),
        .library(name: "AppliveryDynamic", type: .dynamic, targets: ["Applivery"])
	],
	dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", from: "4.0.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "9.0.0"),
        .package(url: "https://github.com/AliSoftware/OHHTTPStubs.git", from: "9.0.0")
	],
	targets: [
		.target(
			name: "Applivery",
			dependencies: [],
			path: "AppliverySDK",
            exclude: ["Info.plist", "Resources/Assets/Media.xcassets"],
            resources: [.process("Resources/Assets")]),
        
		.testTarget(
			name: "AppliveryBehaviorTests",
			dependencies: [
                "Applivery",
                "Quick", "Nimble", "OHHTTPStubs",
                .product(name: "OHHTTPStubsSwift", package: "OHHTTPStubs")],
			path: "AppliveryBehaviorTests",
			exclude: ["Info.plist"],
			resources: [
                .process("./Mocks/JSON"),
                .process("./Mocks/Images")
            ])
	]
)
