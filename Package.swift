// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Wrench",
    products: [
        .executable(name: "wrench", targets: ["Wrench"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kareman/SwiftShell", .branch("master")),
        .package(url: "https://github.com/JohnSundell/Files", .branch("master")),
//        .package(url: "https://github.com/tuist/xcodeproj", from: "6.0.0"),
        .package(url: "https://github.com/drekka/xcodeproj", .branch("feature/project-sorting")),
        //        .package(url: "https://github.com/kareman/FileSmith", from: "0.2.0"),
        .package(url: "https://github.com/apple/swift-package-manager", .branch("master")),
    ],
    targets: [
        .target(
            name: "Wrench",
            dependencies: ["WrenchCore"]
        ),
        .target(
            name: "WrenchCore",
            dependencies: ["Files", "SwiftShell", "Utility", "xcodeproj"]
        ),
        .testTarget(
            name: "WrenchTests",
            dependencies: ["Wrench"]
        ),
    ]
)
