
//  Created by Derek Clarkson on 18/9/18.

import Files
import Utility

struct DirectoryArgument: CommandArgument, FileSourceFactory {

    static let argumentSyntax: String? = "<project-dir>, ..."

    let projectDirs: OptionArgument<[String]>

    var fileSources: [FileSource]? = nil

    init(argumentParser: ArgumentParser) {
        projectDirs = argumentParser.add(option: "--blah",
                                    kind: [String].self,
                                    usage: "Cross references the source files listed in the specified directories with " +
            "those in the project to locate any lost files resulting from a bad merge.")

//        projectDirs = argumentParser.add(positional: "<project-dir>, ...",
//                                         kind: [String].self,
//                                         optional: true,
//                                         strategy: .remaining,
//                                         usage: "Read a list of files to process from one or more directories add at the end of the command. " +
//                                             "Will override any files piped in from another command.")
    }

    func read(arguments: ArgumentParser.Result) throws {
        if let dirs = arguments.get(projectDirs) {
            try dirs.forEach { folderPath in
                if let folder = try? Folder(path: folderPath) {
//                    toolbox.add(fileSource: DirectoryFileSource(directory: folder))
                } else {
                    throw WrenchError.folderNotFound(folderPath)
                }
            }
        }
    }
}
