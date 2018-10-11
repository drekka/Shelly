
//  Created by Derek Clarkson on 5/10/18.

import Basic
import Utility

public protocol FileSourceFactory {
    var fileSources: [FileSource]? { get }
}

public extension FileSourceFactory {

    func set(fileSources: inout [FileSource]?,
             fromArgument argument: PositionalArgument<RelativePathArgument>,
             in arguments: ArgumentParser.Result,
             using: (RelativePathArgument) throws -> FileSource = { DirectoryFileSource(directory: $0.path) }) throws {
        fileSources = try createFileSources(fromDir: arguments.get(argument), using: using)
    }

    func set(fileSources: inout [FileSource]?,
             fromArgument argument: OptionArgument<RelativePathArgument>,
             in arguments: ArgumentParser.Result,
             using: (RelativePathArgument) throws -> FileSource = { DirectoryFileSource(directory: $0.path) }) throws {
        fileSources = try createFileSources(fromDir: arguments.get(argument), using: using)
    }

    func set(fileSources: inout [FileSource]?,
             fromArgument argument: PositionalArgument<[RelativePathArgument]>,
             in arguments: ArgumentParser.Result,
             using: (RelativePathArgument) throws -> FileSource = { DirectoryFileSource(directory: $0.path) }) throws {
        fileSources = try createFileSources(fromDirs: arguments.get(argument), using: using)
    }

    func set(fileSources: inout [FileSource]?,
             fromArgument argument: OptionArgument<[RelativePathArgument]>,
             in arguments: ArgumentParser.Result,
             using: (RelativePathArgument) throws -> FileSource = { DirectoryFileSource(directory: $0.path) }) throws {
        fileSources = try createFileSources(fromDirs: arguments.get(argument), using: using)
    }

    private func createFileSources(fromDir: RelativePathArgument?, using: (RelativePathArgument) throws -> FileSource) throws -> [FileSource]? {
        guard let fromDir = fromDir else {
            return nil
        }
        return [try using(fromDir)]
    }

    private func createFileSources(fromDirs: [RelativePathArgument]?, using: (RelativePathArgument) throws -> FileSource) throws -> [FileSource]? {
        return try fromDirs?.map(using)
    }
}


