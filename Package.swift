// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Wrench",
    products: [
    .executable(name: "wrench", targets:["Wrench"]),
               ],
    dependencies: [
                .package(url: "https://github.com/kareman/SwiftShell", from: "4.0.0"),
                .package(url: "https://github.com/JohnSundell/Files", from: "2.2.0"),
//        .package(url: "https://github.com/drekka/FileSmith", .branch("drekka-patch-1")),
//        .package(url: "https://github.com/kareman/FileSmith", from: "0.2.0"),
        .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.1.0"),
    ],
    targets: [
        .target(
            name: "Wrench",
            dependencies: ["WrenchCore"]
        ),
        .target(
            name: "WrenchCore",
            dependencies: ["Files", "SwiftShell", "Utility"]
        ),
        .testTarget(
            name: "WrenchTests",
            dependencies: ["Wrench"]
        ),
    ]
)
