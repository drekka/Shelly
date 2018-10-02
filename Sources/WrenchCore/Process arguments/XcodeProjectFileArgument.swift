
//  Created by Derek Clarkson on 18/9/18.

import Files
import Utility

struct XCodeProjectFilesArgument: CommandArgument, FileSourceFactory {

    static let argumentSyntax: String? = "<project-file>, ..."

    let projectDirs: PositionalArgument<[String]>

   var fileSources: [FileSource]? = nil

    init(argumentParser: ArgumentParser) {

                projectDirs = argumentParser.add(positional: "<project-dir>, ...",
                                                 kind: [String].self,
                                                 optional: true,
                                                 strategy: .remaining,
                                                 usage: "If you're not sourcing project files from Git, then you can specify them after the arguments to check them.")
    }

    func read(arguments: ArgumentParser.Result) throws {
        if let dirs = arguments.get(projectDirs) {
            try dirs.forEach { folderPath in
                if let folder = try? Folder(path: folderPath) {
                } else {
                    throw WrenchError.folderNotFound(folderPath)
                }
            }
        }
    }
}
