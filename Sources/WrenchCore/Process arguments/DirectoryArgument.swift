
//  Created by Derek Clarkson on 18/9/18.

import Files
import Utility

class DirectoryArgument: CommandArgument, FileSourceFactory {

    static let argumentSyntax: String? = "<project-dir>, ..."

    let projectDirs: PositionalArgument<[PathArgument]>

    var fileSources: [FileSource]? = nil

    required init(argumentParser: ArgumentParser) {
        projectDirs = argumentParser.add(positional: "<project-dir>, ...",
                                         kind: [PathArgument].self,
                                         optional: true,
                                         strategy: .remaining,
                                         usage: "Read a list of files to process from one or more directories add at the end of the command. " +
            "Will override any files piped in from another command.")
    }

    func read(arguments: ArgumentParser.Result) throws {

        guard let dirs = arguments.get(projectDirs) else {
            return
        }

        fileSources = try dirs.map { folderPath in
            if let folder = try? Folder(path: folderPath) {
                return DirectoryFileSource(directory: folder)
            } else {
                throw WrenchError.folderNotFound(folderPath)
            }
        }
    }
}
