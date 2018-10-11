// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Wrench",
    products: [
        .executable(name: "wrench", targets: ["Wrench"]),
    ],
    dependencies: [
    .package(url: "https://github.com/Quick/Nimble", from: "7.0.0"),
        .package(url: "https://github.com/kareman/SwiftShell", .branch("master")),
        .package(url: "https://github.com/tuist/xcodeproj", .branch("master")),
//        .package(url: "https://github.com/drekka/xcodeproj", .branch("feature/project-sorting")),
//        .package(url: "https://github.com/apple/swift-package-manager", from: "0.3.0"),
        .package(url: "https://github.com/drekka/swift-package-manager", .branch("feature/everything")),
    ],
    targets: [
        .target(
            name: "Wrench",
            dependencies: ["Shelly", "xcodeproj"]
        ),
        .target(
            name: "Shelly",
            dependencies: ["SwiftShell", "Utility"]
        ),
        .testTarget(
            name: "WrenchTests",
            dependencies: ["Wrench", "Nimble"]
        ),
    ]
)
