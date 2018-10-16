# Shelly
Version: 1.0

Shelly is a framework which makes writing command line applications simpler. It provides common functionality in a manner that lets you concentrate on the functionality of your command and not how it's managed.

**Features**

* Supports command line programs with sub-commands.
* Prebuilt common file list sources.
* Prebuilt common arguments.
* Minimal code requirements to write commands.
* Argument validation and processing.

Table of Contents
=================

   * [Shelly](#shelly)
   * [Table of Contents](#table-of-contents)
   * [Adding to your project](#adding-to-your-project)
      * [Swift Package Manager](#swift-package-manager)
      * [Carthage](#carthage)
   * [Quick start - Creating a command line program](#quick-start---creating-a-command-line-program)
      * [Initial setup](#initial-setup)
      * [Main](#main)
      * [Main class](#main-class)
      * [Adding functionality](#adding-functionality)
         * [Single process implementation](#single-process-implementation)
         * [Sub-command implementation](#sub-command-implementation)



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

# Quick start - Creating a command line program

Creating a command line program using Shelly isn't especially hard and the simplest way to do it is to use [Swift's Package Manager](https://swift.org/package-manager/). You can start by building your project manually using [Xcode](https://developer.apple.com/xcode/) and [Carthage 😃](https://github.com/Carthage/Carthage) or [CocoaPods](https://github.com/CocoaPods/CocoaPods), but SPM has the advantage in that it makes it easy to compile all the 3rd party dependencies and Swift libraries into a single executable which you then distribute.

So in this guide I'll build a simple command line program called `lister` using SPM as the core tooling.

## Initial setup

first we need to do some initial setup by creating a directory and running the SPM initialiser command in it:

```bash
~ $ mkdir lister
~ $ cd lister
lister $ swift package init --type executable
```

This creates a template for a new project including some initial source and tests files. Now we need to add some dependencies. In our case, Shelly and [Nimble](https://github.com/Quick/Nimble) (which I recommend using with [XCTest](https://developer.apple.com/documentation/xctest)) to the `Package.swift` file which defines the project, so open it and replace it's contents with this:

```swift
// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Lister",
    products: [
        .executable(name: "lister", targets: ["Lister"]),
        ],
    dependencies: [
        .package(url: "https://github.com/Quick/Nimble", from: "7.0.0"),
        .package(url: "https://github.com/drekka/Shelly", .branch("master")),
        ],
    targets: [
        .target(
            name: "Lister",
            dependencies: ["Shelly", ]
        ),
        .testTarget(
            name: "ListerTests",
            dependencies: ["Lister", "Nimble", ]
        ),
        ]
)
```

Next we need to download the dependencies and install them. use this command:

```bash
lister $ swift package update
```

Once that's finished we can create the project file using SPM. It will automatically create all the necessary targets and schemes:

```bash
lister $ swift package generate-xcodeproj --enable-code-coverage
``` 

And we're done. Opening the `Lister.xcodeproj` file will show you the project ready for adding your functionality.

## Main

The next thing to do is update the access point to your program. It's fairly simple as we're going to get another Swift class (`Lister`) to do the real work. Edit `main.swift` and add this code:

```swift
import Foundation

do {
    try Lister()
} catch let error {
    Lister.logError(String(describing: error))
    exit(1)
}
```

## Main class

Now we need to create the main class of the program. Create a swift file called `Lister.swift` assigned to the 'Lister' program target and add this content:

```swift
import Shelly

public class Lister: ShellCommand {

    @discardableResult init() throws {
        try super.init(command: "lister",
                   overview: "Listing files super easily.",
                   argumentClasses: [
                       VerboseArgument.self,
                       RootDirectoryArgument.self,
                       ]
                    )
    }
}
```

We've just defined our program. Shelly's `ShellCommand` class has a load of functionality built into it include the processing of arguments you pass to your command so lets try it out. Go back to the command line and execute this command:

```bash
lister $ swift build -c release -Xswiftc -static-stdlib
```

This will build a release version of the command line program including all it's dependencies and the Swift runtime in a single file binary executable. At the end of the build it should print something like this to tell you where the program is:

```bash
Linking ./.build/x86_64-apple-macosx10.10/release/lister
```

Now try executing it like this:

```bash
lister $ .build/x86_64-apple-macosx10.10/release/lister --help
OVERVIEW: Listing files super easily.

USAGE: lister [--help] [--verbose] [--project-dir <dir>] ...

OPTIONS:
  --project-dir   Base directory of the project. Defaults to the current directory.
  --verbose       Turns on verbose output for debugging purposes.
  --help          Display available options
```

Yey it works. As you can see Shelly has fleshed out the program, adding arguments for verbose and setting a directory. If you look back at the `Lister.swift` file you can see exactly where these arguments where defined through passing a list of argument classes to super. Argument classes defined here are added as arguments to the main program.

## Adding functionality

Generally speaking there are two forms of command line programs. ***Single process*** and ***Sub-command*** based.

### Single process implementation

Single process programs have a single function. For example `ls` lists files, `rm` removes files, etc.

Here's our `lister` class with a single process implemetation:

```swift
import Shelly
import Basic

public class Lister: ShellCommand {

    @discardableResult init() throws {
        try super.init(command: "lister",
                       overview: "Listing files super easily.",
                       process: { _ in
                        let files = try DirectoryFileSource(directory: RelativePath(".")).getFiles()
                        files.sorted { $0.asString < $1.asString }.forEach { file in
                            ShellCommand.log("File: \(file.asString)")
                        }
        },
            argumentClasses: [
                VerboseArgument.self,
                RootDirectoryArgument.self,
                ]
        )
    }
}
```

We've added a `process` argument to the setup which defines a closure that is executed. Pretty simple. The closure takes an argument which contains all the processed arguments passed to the program. We'll look at reading those shortly. Now building and running will produce something like this:

```bash
lister $ swift build -c release -Xswiftc -static-stdlib
Compile Swift Module 'Shelly' (23 sources)
Compile Swift Module 'Lister' (2 sources)
Linking ./.build/x86_64-apple-macosx10.10/release/lister
lister $ .build/x86_64-apple-macosx10.10/release/lister
File: .build
File: .build/build.db
File: .build/checkouts
File: .build/checkouts/Nimble-6408981098330508121
...
```

Not particularly helpful because it's list all the files in the current directory and there's a lot. Something like this is more interesting:

```bash
lister $ .build/x86_64-apple-macosx10.10/release/lister --project-dir ~/Documents
```

### Sub-command implementation

Sub-command based programs require you to specify a sub-command to tell them what you want to do. For example `swift package` or `git pull`. 

To add a sub-command we first need a sub-command class. Add a file to the project called `List.swift` and add this content to it (remember to assign it to the `lister` target):

```swift
import Basic
import Utility
import Shelly

class List: SubCommand {

    private var arguments: [String: CommandArgument] = [:]

    required init() {}

    func configure(_ commandParser: ArgumentParser) throws -> String {
        let cmd = "list"
        arguments = try configure(commandParser, subCommand: cmd, overview: "Lists files")
        return cmd
    }

    func map(_ parseResults: ArgumentParser.Result) throws {
        try map(parseResults, intoArguments: arguments)
    }

    func execute() throws {
        let files = try DirectoryFileSource(directory: RelativePath(".")).getFiles()
        files.sorted { $0.asString < $1.asString }.forEach { file in
            ShellCommand.log("File: \(file.asString)")
        }
    }
}
```
 