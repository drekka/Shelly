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
> wrench <command> <command args>
```

# Installing

Wrench is a OS X command line program. It can be installed by downloading a package from ... and installing it.

