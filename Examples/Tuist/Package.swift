// swift-tools-version: 5.9
import PackageDescription

#if TUIST
import ProjectDescription

let packageSettings = PackageSettings(
    // Customize the product types for specific package product
    // Default is .staticFramework
    // productTypes: ["Alamofire": .framework,]
    productTypes: [
        "Segment-MoEngage": .framework,
        "Segment-Swift-MoEngage": .framework,
        "Segment": .framework,
        "Sovran": .framework,
        "JSONSafeEncoding": .framework,
    ],
    projectOptions: [
        "Segment-MoEngage": .options(automaticSchemesOptions: .enabled())
    ]
)
#endif

let package = Package(
    name: "Examples",
    dependencies: [
        // Add your own dependencies here:
        // .package(url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
        // You can read more about dependencies here: https://docs.tuist.io/documentation/tuist/dependencies
        .package(name: "Segment-MoEngage", path: "../../")
    ]
)
