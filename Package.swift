// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Shelly",
    products: [
        .library(name: "Shelly", targets: ["Shelly"]),
    ],
    dependencies: [
    .package(url: "https://github.com/Quick/Nimble", from: "7.0.0"),
        .package(url: "https://github.com/kareman/SwiftShell", .branch("master")),
        .package(url: "https://github.com/apple/swift-package-manager", from: "0.3.0"),
    ],
    targets: [
        .target(
            name: "Shelly",
            dependencies: ["SwiftShell", "Utility"]
        ),
        .testTarget(
            name: "ShellyTests",
            dependencies: ["Shelly", "Nimble"]
        ),
    ]
)
