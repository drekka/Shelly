
//  Created by Derek Clarkson on 18/9/18.

import Utility

public class SourceDirectoriesArgument: Argument, FileSourceFactory {

    public static let argumentSyntax = "--source-dirs <source-dir> ..."

    private let sourceDirectories: OptionArgument<[LocalPathArgument]>

    private(set) public var fileSources: [FileSource]?

    public required init(argumentParser: ArgumentParser) {
        sourceDirectories = argumentParser.add(option: "--source-dirs",
                                               kind: [LocalPathArgument].self,
                                               usage: "A list of directories where the sources for the project can be found.",
                                               optional: false)
    }

    public func  map(_ parseResults: ArgumentParser.Result) throws {
        fileSources = parseResults.get(sourceDirectories)?.map { return DirectoryFileSource(directory: $0.relativePath) }
    }
}

public class TrailingSourceDirectoriesArgument: Argument, FileSourceFactory {

    public static let argumentSyntax = "<source-dir> ..."

    private let sourceDirectories: PositionalArgument<[LocalPathArgument]>

    private(set) public var fileSources: [FileSource]?

    public required init(argumentParser: ArgumentParser) {
        sourceDirectories = argumentParser.add(positional: "<source-dir>, ...",
                                               kind: [LocalPathArgument].self,
                                               optional: true,
                                               strategy: .remaining,
                                               usage: "Zero or more source directories.")
    }

    public func  map(_ parseResults: ArgumentParser.Result) throws {
        fileSources = parseResults.get(sourceDirectories)?.map { return DirectoryFileSource(directory: $0.relativePath) }
    }
}
