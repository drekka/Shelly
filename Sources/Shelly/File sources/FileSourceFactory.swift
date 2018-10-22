
//  Created by Derek Clarkson on 5/10/18.

import Basic
import Utility

public protocol FileSourceFactory {
    var fileSources: [FileSource]? { get }
    func getFileSources(fromArgument argument: PositionalArgument<[RelativePathArgument]>, in parseResults: ArgumentParser.Result) -> [FileSource]?
    func getFileSources(fromArgument argument: OptionArgument<[RelativePathArgument]>, in parseResults: ArgumentParser.Result) -> [FileSource]?
}

public extension FileSourceFactory {

    func getFileSources(fromArgument argument: PositionalArgument<[RelativePathArgument]>, in parseResults: ArgumentParser.Result) -> [FileSource]? {
        return parseResults.get(argument)?.map { return DirectoryFileSource(directory: $0.path) }
    }

    func getFileSources(fromArgument argument: OptionArgument<[RelativePathArgument]>, in parseResults: ArgumentParser.Result) -> [FileSource]? {
        return parseResults.get(argument)?.map { return DirectoryFileSource(directory: $0.path) }
    }
}
