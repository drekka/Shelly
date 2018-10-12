# Shelly
Version: 1.0

Shelly is a framework which makes writing command line applications simpler by providing a lot of common functionality in a manner that lets you concentrate on the functionality of your command.

**Features**

* Supports command line programs with sub-commands.
* Prebuilt file list sources.
* Prebuilt common arguments.
* Minimal code requirements to write commands.
* Argument validation and processing.

# Adding to your project

## Swift Package Manager

Add Shelly to your `Package.swift` file like any other dependency:

```
let package = Package(
    name: "YourApp",
    products: [
        .executable(name: "yourapp", targets: ["YourApp"]),
    ],
    dependencies: [
        .package(url: "https://github.com/drekka/Shelly", .branch("master")),
    ],
    targets: [
        .target(
            name: "yourApp",
            dependencies: ["Shelly"]
        ),
    ]
)
```

## Carthage

Simply add this to your `Cartfile`:

```
github "drekka/Shelly" "master"
```

# Guide



