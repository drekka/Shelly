
//  Created by Derek Clarkson on 18/9/18.

import Utility

public class SourceDirectoriesArgument: CommandArgument, FileSourceFactory {

    public static let argumentSyntax = "--source-dirs <source-dir> ..."

    private let sourceDirectories: OptionArgument<[RelativePathArgument]>

    private(set) public var fileSources: [FileSource]?

    public required init(argumentParser: ArgumentParser) {
        sourceDirectories = argumentParser.add(option: "--source-dirs",
                                               kind: [RelativePathArgument].self,
                                               usage: "A list of directories where the sources for the project can be found.",
                                               optional: false)
    }

    public func  map(_ parseResults: ArgumentParser.Result) throws {
        fileSources = getFileSources(fromArgument: sourceDirectories, in: parseResults)
    }
}

public class TrailingSourceDirectoriesArgument: CommandArgument, FileSourceFactory {

    public static let argumentSyntax = "<source-dir> ..."

    private let sourceDirectories: PositionalArgument<[RelativePathArgument]>

    private(set) public var fileSources: [FileSource]?

    public required init(argumentParser: ArgumentParser) {
        sourceDirectories = argumentParser.add(positional: "<source-dir>, ...",
                                               kind: [RelativePathArgument].self,
                                               optional: true,
                                               strategy: .remaining,
                                               usage: "Zero or more source directories.")
    }

    public func  map(_ parseResults: ArgumentParser.Result) throws {
        fileSources = getFileSources(fromArgument: sourceDirectories, in: parseResults)
    }
}
