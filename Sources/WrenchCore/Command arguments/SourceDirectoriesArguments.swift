
//  Created by Derek Clarkson on 18/9/18.

import Utility

class SourceDirectoriesArgument: CommandArgument, FileSourceFactory {

    static let argumentSyntax = "--source-dirs <source-dir> ..."

    private let sourceDirectories: OptionArgument<[RelativePathArgument]>

    private(set) var fileSources: [FileSource]?

    required init(argumentParser: ArgumentParser) {
        sourceDirectories = argumentParser.add(option: "--source-dirs",
                                               kind: [RelativePathArgument].self,
                                               usage: "A list of directories where the sources for the project can be found.",
                                               optional: false)
    }

    func parse(arguments: ArgumentParser.Result) throws {
        try set(fileSources: &fileSources, fromArgument: sourceDirectories, in: arguments)
    }
}

class TrailingSourceDirectoriesArgument: CommandArgument, FileSourceFactory {

    static let argumentSyntax = "<source-dir> ..."

    private let sourceDirectories: PositionalArgument<[RelativePathArgument]>

    private(set) var fileSources: [FileSource]?

    required init(argumentParser: ArgumentParser) {
        sourceDirectories = argumentParser.add(positional: "<source-dir>, ...",
                                               kind: [RelativePathArgument].self,
                                               optional: true,
                                               strategy: .remaining,
                                               usage: "Zero or more source directories.")
    }

    func parse(arguments: ArgumentParser.Result) throws {
        try set(fileSources: &fileSources, fromArgument: sourceDirectories, in: arguments)
    }
}
