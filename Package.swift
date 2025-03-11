// swift-tools-version:5.3
// This file generated from post_build script, modify the script instaed of this file.

// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Segment-MoEngage",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "Segment-MoEngage", targets: ["Segment-MoEngage"]),
    ],
    dependencies: [
        .package(url: "https://github.com/segmentio/analytics-swift.git", from: "1.3.1"),
        .package(url: "https://github.com/moengage/apple-sdk.git", "9.23.0"..<"9.24.0")
    ],
    targets: [
        .target(
            name: "Segment-MoEngage",
            dependencies: [
                .product(name: "Segment", package: "analytics-swift"),
                .product(name: "MoEngage-iOS-SDK", package: "apple-sdk")
            ],
            path: "Sources/MoEngage-Swift-Segment"),
        .testTarget(name: "Segment-MoEngageTests", dependencies: ["Segment-MoEngage"]),
    ],
    swiftLanguageVersions: [.v5]
)
