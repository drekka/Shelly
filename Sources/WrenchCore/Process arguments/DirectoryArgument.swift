
//  Created by Derek Clarkson on 18/9/18.

import Utility
import Files

struct DirectoryArgument: CommandArgument {
    
    static let argumentSyntax: String? = "<project-dir>, ..."
    
    let projectDirs: PositionalArgument<[String]>
    
    init(argumentParser: ArgumentParser) {
        projectDirs = argumentParser.add(positional: "<project-dir>, ...",
                                         kind: [String].self,
                                         optional: true,
                                         strategy: .remaining,
                                         usage: "Read a list of files to process from one or more directories add at the end of the command. " +
            "Will override any files piped in from another command.")
    }
    
    func activate(arguments: ArgumentParser.Result, toolbox: Toolbox) throws {
        if let dirs = arguments.get(projectDirs) {
            try dirs.forEach { folderPath in
                if let folder = try? Folder(path: folderPath) {
                    toolbox.addFileSource(DirectoryFileSource(directory: folder))
                } else {
                    throw WrenchError.folderNotFound(folderPath)
                }
            }
        }
    }
}

