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
   * [Creating a command line program](#creating-a-command-line-program)
      * [Initial setup](#initial-setup)
      * [Main](#main)
      * [Main class](#main-class)
      * [Adding functionality](#adding-functionality)
         * [Single process implementation](#single-process-implementation)
         * [Sub-command implementation](#sub-command-implementation)
            * [Adding sub-command arguments](#adding-sub-command-arguments)
      * [Custom arguments](#custom-arguments)
      * [File sources](#file-sources)
         * [Custom file sources](#custom-file-sources)

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

# Creating a command line program

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
                       ])
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

***Note: For the simplicity of this readme, I'm going to assume you'll now add a symlink pointing at the compiled program to avoiding typing the full path like this:***

```bash
lister $ ln -s .build/x86_64-apple-macosx10.10/release/lister lister
```


Try executing it like this:

```bash
lister $ ./lister --help
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
                        ])
    }
}
```

We've added a `process` argument to the setup which defines a closure that is executed. Pretty simple. The closure takes an argument which contains all the processed arguments passed to the program. We'll look at reading those shortly. Now building and running will produce something like this:

```bash
lister $ swift build -c release -Xswiftc -static-stdlib
Compile Swift Module 'Shelly' (23 sources)
Compile Swift Module 'Lister' (2 sources)
Linking ./.build/x86_64-apple-macosx10.10/release/lister
lister $ ./lister
File: .build
File: .build/build.db
File: .build/checkouts
File: .build/checkouts/Nimble-6408981098330508121
...
```

Not particularly helpful because it's listing the current directory. But we have a project dir argument which will change to the passed directory. Using that we can list files from another directory like this without requiring any new code from you:

```bash
lister $ ./lister --project-dir ~/Documents
```

### Sub-command implementation

Sub-command based programs require you to specify a sub-command to tell them what you want to do. For example `swift package` or `git pull`. 

To add a sub-command we first need a sub-command class. Add a file to the project called `List.swift` and add this content to it (remember to assign it to the `lister` target):

```swift
import Basic
import Utility
import Shelly

class List: SubCommand {

    private(set) var arguments: [String: Argument] = [:]

    required init() {}

    func configure(_ commandParser: ArgumentParser) throws -> String {
        let cmd = "list"
        arguments = try configure(commandParser, subCommand: cmd, overview: "Lists files")
        return cmd
    }
    
    func execute() throws {
        let files = try DirectoryFileSource(directory: RelativePath(".")).getFiles()
        files.sorted { $0.asString < $1.asString }.forEach { file in
            ShellCommand.log("File: \(file.asString)")
        }
    }
}
```
 
Again Shelly does as much work as possible so you don't have to. All you need to do is to implement the `configure(_:)` method and ensure it calls the `configure(_:,_:,_:)` method to finish registering the sub-command, then implement the `execute()` method to perform the task.
 
Finally we need to add the sub-command to the main program:

```swift
public class Lister: ShellCommand {
    
    @discardableResult init() throws {
        try super.init(command: "lister",
                       overview: "Listing files super easily.",
                       subCommandClasses: [List.self],
                       argumentClasses: [
                           VerboseArgument.self,
                           RootDirectoryArgument.self,
                       ]
        )
    }
}
```

And now you can call it like this:

```bash
lister $ ./lister --project-dir ~/Documents list
```

Note how we are passing `--project-dir ~/Documents` before the `list` sub-command. This is because the argument has been added to the program, not the subcommand and all program arounds must occur before the subcommand.

#### Adding sub-command arguments

Here's how we add the `--project-dir` argument to the sub-command instead of the program: 

```swift
func configure(_ commandParser: ArgumentParser) throws -> String {
    let cmd = "list"
    Arguments = try configure(commandParser, 
                              subCommand: cmd,
                              overview: "Lists files",
                              argumentClasses: [ProjectDirectoryArgument.self])
    return cmd
}
```

Easy. Now you can call it like this:

```bash
lister $ ./lister list --project-dir ~/Documents
```

Of course in this example we'd also remove it from the list of arguments in `Lister.swift` because it would make no sense to have this argument at both levels.


## Arguments

Shelly provides the following list of pre-defined arguments:

| Argument | Syntax | properties | Description |
| --- | --- | --- | --- |
| `ExcludeArgument` | `--exclude <mask> <mask? ...` | `var excludeMasks: [String]?` | List of masks that can be used to filter files. |
| `GitChangesArgument` | | | `FileSourceFactory` implementation that generates a `FileSource` listing of all files that Git thinks have been changed. |
| `GitStagingArgument` | | | `FileSourceFactory` implementation that generates a `FileSource` of all files in the Git staging area. |
| `ProjectDirectoryArgument` | `--project-dir directory` | | Changing the file systems current working directory to the specified one. |
| `SourceDirectoriesArgument` | `--source-dirs <dir> ....` | | `FileSourceFactory` implementation that generates an array of `FileSource`s, one for each of the passed directories. |
| `TrailingSourceDirectoriesArgument` | `<dir> ....` | | Only usable as the last argument in the list, this `FileSourceFactory` implementation generates an array of `FileSource`s, one for each of the remaining arguments. |
| `VerboseArgument` | `--verbose` | | Sets a global static variable called `ShellCommand.verbose` which can be tested when deciding what to output. |

### Custom argument

Creating your own argument for your command is quite easy. As an example, lets create a simple argument that prints 'hello' when used. Here's the definition of it:

```swift
import Shelly
import Utility

class Hello: Argument {

    static var argumentSyntax = "[—hello]"

    private let helloArgument: OptionArgument<Bool>

    var sayHello: Bool = false

    required init(argumentParser: ArgumentParser) {
        helloArgument = argumentParser.add(option: "--hello", kind: Bool.self, usage: "Say Hello!")
    }

    public func map(_ parseResults: ArgumentParser.Result) throws {
        if parseResults.get(helloArgument) != nil {
            sayHello = true
        }
    }
}
```

And lets add it to the main program:

```swift
try super.init(command: "lister",
               overview: "Listing files super easily.",
               process: { argumentMapper in

                   let hello: Hello = try argumentMapper.getArgument()
                   if hello.sayHello {
                       ShellCommand.log("Hello!")
                   }

                   let files = try DirectoryFileSource(directory: RelativePath(".")).getFiles()
                   files.sorted { $0.asString < $1.asString }.forEach { file in
                       ShellCommand.log("File: \(file.asString)")
                   }
               },
               argumentClasses: [
                   Hello.self,
                   VerboseArgument.self,
                   ProjectDirectoryArgument.self,
               ])
```

As you can see we've added `Hello.self` to the list of arguments and in the process closure, we've retrieved the argument from the `ArgumentMapper` and acted based on its value. Now lets try it out:

```bash
Lister $ ./lister --project-dir ~/Documents --hello
Hello!
File: .DS_Store
File: .localized
Program ended with exit code: 0
```

## File sources

As you may hav noticed, some of the builtin arguments act as `FileSourceFactory`s. These produce one or more `FileSource` instances which in turn can produce a list of files. For example the files in a directory or in the Git staging area.

As a command may want to obtain a list of files from a number of sources, Shelly has functionality to obtain those lists and merge them into a single (de-duplicated) master list for your program to use.


### Custom file sources 
