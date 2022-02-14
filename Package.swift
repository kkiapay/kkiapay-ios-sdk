// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KKiaPaySDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "KKiaPaySDK",
            targets: ["KKiaPaySDK"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "KKiaPaySDK",
            dependencies: []),
        .testTarget(
            name: "KKiaPaySDKTests",
            dependencies: ["KKiaPaySDK"]),
    ]
)
