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
                .package(product: "Segment-MoEngage", type: .runtime)
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
