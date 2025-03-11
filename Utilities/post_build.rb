#!/usr/bin/ruby

# Usage:
# Update Package.swift, version constants as per package.json

require 'json'

config = JSON.parse(File.read('package.json'), {object_class: OpenStruct})

package_swift = <<PACKAGE
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
        .package(url: "https://github.com/segmentio/analytics-swift.git", from: "#{config.segmentVersion}"),
        .package(url: "https://github.com/moengage/apple-sdk.git", "#{config.sdkVerMin}"..<"#{config.sdkVerMax}")
    ],
    targets: [
        .target(
            name: "Segment-MoEngage",
            dependencies: [
                .product(name: "Segment", package: "analytics-swift"),
                .product(name: "MoEngage-iOS-SDK", package: "MoEngage-iOS-SDK")
            ],
            path: "Sources/MoEngage-Swift-Segment"),
        .testTarget(name: "Segment-MoEngageTests", dependencies: ["Segment-MoEngage"]),
    ],
    swiftLanguageVersions: [.v5]
)
PACKAGE

version_constant = <<CONSTANTS
// This file generated from post_build script, modify the script instaed of this file.
import Foundation

extension MoEngageSegmentConstant {
    static let segmentVersion = "#{config.packages[0].version}"
}
CONSTANTS

File.open('Package.swift', 'w') do |file|
  file.write(package_swift)
end

File.open('Sources/MoEngage-Swift-Segment/MoEngageSegmentConstants+Version.swift', 'w') do |file|
  file.write(version_constant)
end
