
//  Created by Derek Clarkson on 18/9/18.

import Utility
import Files

struct DirectoryArgument: CommandArgument {
    
    let projectDirs: PositionalArgument<[String]>
    
    init(argumentParser: ArgumentParser) {
        projectDirs = argumentParser.add(positional: "<project-dir>, ...",
                                         kind: [String].self,
                                         optional: true,
                                         strategy: .remaining,
                                         usage: "Zero or more project directories to look for Xcode project files in. Will override any files piped in from another command.")
    }
    
    func activate(arguments: ArgumentParser.Result, toolbox: Toolbox) throws {
        if let dirs = arguments.get(projectDirs) {
            try dirs.forEach {
                toolbox.addFileSource(DirectoryFileSource(directory: try Folder(path: $0)))
            }
        }
    }
}

