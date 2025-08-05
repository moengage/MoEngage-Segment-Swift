import ProjectDescription

let defaultSettings: SettingsDictionary = [:]
    .codeSignIdentity("iPhone Developer")
    .merging([
        "GENERATE_INFOPLIST_FILE": true
    ])

let project = Project(
    name: "MoEngageSegment",
    packages: [
        .local(path: "../")
    ],
    targets: [
        // Sample Apps
        .target(
            name: "MoEngageTuistApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.alphadevs.MoEngage",
            deploymentTargets: .iOS("13.0"),
            infoPlist: "MoEngageApp/Info.plist",
            sources: ["MoEngageApp/**/*.{swift,h,m}"],
            resources: [
                "MoEngageApp/**/*.{xcassets,png,gpx,wav,mp3,ttf,xib,storyboard}"
            ],
            headers: .headers(public: "MoEngageApp/**/*.h"),
            entitlements: "MoEngageApp/MoEngageApp.entitlements",
            dependencies: [
                .external(name: "Segment-MoEngage"),
                .external(name: "MoEngageRichNotification"),
                // Enable tuist integrated dependency and disable package dependency before enabling this
                .target(name: "NotificationService", condition: nil),
                .target(name: "NotificationContent", condition: nil),

            ],
            settings: .settings(
                base: defaultSettings
                    .marketingVersion("1.0.0")
                    .currentProjectVersion("1.0.0")
            )
        ),
        .target(
            name: "MoEngageSPMApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.alphadevs.MoEngage",
            deploymentTargets: .iOS("13.0"),
            infoPlist: "MoEngageApp/Info.plist",
            sources: ["MoEngageApp/**/*.{swift,h,m}"],
            resources: [
                "MoEngageApp/**/*.{xcassets,png,gpx,wav,mp3,ttf,xib,storyboard}"
            ],
            headers: .headers(public: "MoEngageApp/**/*.h"),
            entitlements: "MoEngageApp/MoEngageApp.entitlements",
            dependencies: [
                .package(product: "Segment-MoEngage", type: .runtime),
                .package(product: "MoEngageRichNotification", type: .runtime),
                // .target(name: "NotificationService", condition: nil),
                // .target(name: "NotificationContent", condition: nil),
            ],
            settings: .settings(
                base: defaultSettings
                    .marketingVersion("1.0.0")
                    .currentProjectVersion("1.0.0")
            )
        ),
        // manually add xcframeworks to this target to test
        .target(
            name: "MoEngageManualApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.alphadevs.MoEngage",
            deploymentTargets: .iOS("13.0"),
            infoPlist: "MoEngageApp/Info.plist",
            sources: ["MoEngageApp/**/*.{swift,h,m}"],
            resources: [
                "MoEngageApp/**/*.{xcassets,png,gpx,wav,mp3,ttf,xib,storyboard}"
            ],
            headers: .headers(public: "MoEngageApp/**/*.h"),
            entitlements: "MoEngageApp/MoEngageApp.entitlements",
            dependencies: [
                // Diable package and external dependency in extensions,
                // use XCFrameworks with Don not embed option
                // .target(name: "NotificationService", condition: nil),
                // .target(name: "NotificationContent", condition: nil),
            ],
            settings: .settings(
                base: defaultSettings
                    .marketingVersion("1.0.0")
                    .currentProjectVersion("1.0.0")
            )
        ),

        // Extensions
        .target(
            name: "NotificationService",
            destinations: .iOS,
            product: .appExtension,
            bundleId: "com.alphadevs.MoEngage.NotificationService",
            deploymentTargets: .iOS("13.0"),
            infoPlist: "NotificationService/Info.plist",
            sources: ["NotificationService/**/*.{swift,h,m}"],
            entitlements: "NotificationService/NotificationService.entitlements",
            dependencies: [
                // For MoEngageSPMApp integration, we use the package dependency
                // .package(product: "MoEngage-iOS-SDK", type: .runtime),
                // .package(product: "MoEngageRichNotification", type: .runtime),
                // For MoEngageTuistApp integration, we use the external dependency
                .external(name: "MoEngage-iOS-SDK"),
                .external(name: "MoEngageRichNotification"),
            ],
            settings: .settings(
                base: defaultSettings
                    .marketingVersion("1.0.0")
                    .currentProjectVersion("1.0.0")
            )
        ),
        .target(
            name: "NotificationContent",
            destinations: .iOS,
            product: .appExtension,
            bundleId: "com.alphadevs.MoEngage.NotificationContent",
            deploymentTargets: .iOS("13.0"),
            infoPlist: "NotificationContent/Info.plist",
            sources: ["NotificationContent/**/*.{swift,h,m}"],
            resources: ["NotificationContent/**/*.{xib,storyboard,xcassets}"],
            entitlements: "NotificationContent/NotificationContent.entitlements",
            dependencies: [
                // For MoEngageSPMApp integration, we use the package dependency
                // .package(product: "MoEngage-iOS-SDK", type: .runtime),
                // .package(product: "MoEngageRichNotification", type: .runtime),
                // For MoEngageTuistApp integration, we use the external dependency
                .external(name: "MoEngage-iOS-SDK"),
                .external(name: "MoEngageRichNotification"),
            ],
            settings: .settings(
                base: defaultSettings
                    .marketingVersion("1.0.0")
                    .currentProjectVersion("1.0.0")
            )
        ),
    ],
    additionalFiles: ["../Utilities", "../Rakefile", "../LICENSE", "../package.json", "../*.md"],
    resourceSynthesizers: []
)
