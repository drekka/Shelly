# Wrench

Wrench looks after your Xcode project with a variety of maintenance processes to keep it in tip top condiction.

* __Project file sorting__. Invaluable in multi-developer projects as it solves a lot of profile file merge issues before they happen.
* __Lost file reporting__. The lost file report shows all file references in the project which no longer exist on your drive and all files on the drive which are not included in the project.
* __Report on duplicate assets__ (Not implemented). Searches asset libraries for multiple references to the same asset which can be consolidated.
* __Auto insert/update Carthage copy file build phases__ (not implemented).
* __Unnecessary build artifacts__ (not implemented). Things being added to the build targets which aren't needed. Info.plist files for example.
* __Double compilations__ (not implemented). Files appearing more than once in a compilation build phases.
* __SwiftFormat__ (not implemented). SwiftFormat can be used as a framework and I'd like to include it as a runnable wrench.

## Running Wrench

```
> wrench —git-scan-staging —sort
```

# Installing

Wrench is a OS X command line program. It can be installed by downloading a package from ... and installing it.

# Developing

Wrench uses the following types of core components:

* __`Mechanic`__ is the main processing class.
* __`CommandArgument`__ instances which define and process the arguments controlling Wrench.
* __`FileSource`__ instances which source files to process. For example from a passed directory name or from the Git staging area. Generally speaking these lists drive the processing.
* __`Wrench`__ instances which perform the maintenance processing.

The `Mechanic` follows this process when executing:

1. Loop through all the `CommandArgument` instances and asks them to check the passed arguments. If the `CommandArgument` instance sees the arguments it's interested in, it configures and adds the `FileSource` and `Wrench` instances needed by the `Mechanic` to perform the task.
1. The `Mechanic` then asks each `Wrench` instance for a filter which defines the files the wrench accepts. 
2. The mechanic then loops through all of the added `FileSource` instances, passing the files through the file filters and into the wrenches.
3. Finally the `Mechanic` calls each of the `Wrench` instances in turn and tells them to run their process.

## Adding a new wrench

1. Checkout and open the Wrench project.
2. Create a new class and implement the `Wrench` protocol on it.
3. (Optional) Create a new class and implement the `FileSource` protocol on it if you need a new file source.
4. Create a new class and implement the `CommandArgument` protocol to define the new command argument.
5. Add the `CommandArgument` to the list of command arguments in the `Mechanic`.



