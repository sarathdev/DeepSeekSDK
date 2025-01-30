// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "DeepSeekSDK",
    platforms: [.iOS(.v13)], // Minimum iOS version
    products: [
        .library(
            name: "DeepSeekSDK",
            targets: ["DeepSeekSDK"]),
    ],
    targets: [
        .target(
            name: "DeepSeekSDK",
            dependencies: []),
        .testTarget(
            name: "DeepSeekSDKTests",
            dependencies: ["DeepSeekSDK"]),
    ]
)