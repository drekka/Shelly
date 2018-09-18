
//  Created by Derek Clarkson on 18/9/18.

import Utility
import Files

struct GitStagingArgument: CommandArgument {
    
    private let scanGitStaging: OptionArgument<Bool>
    
    init(argumentParser: ArgumentParser) {
        scanGitStaging = argumentParser.add(option: "--scan-git-staging",
                                            kind: Bool.self,
                                            usage: "Scans the Git staging area for project files.")
    }
    
    func activate(arguments: ArgumentParser.Result, toolbox: Toolbox) throws {
        if arguments.get(scanGitStaging) ?? false {
            toolbox.addFileSource(GitStagingFileSource())
        }
    }
}

