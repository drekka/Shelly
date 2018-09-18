
//  Created by Derek Clarkson on 18/9/18.

import Utility
import Files

struct GitChangesArgument: CommandArgument {

    private let scanGitChanges: OptionArgument<Bool>
    
    init(argumentParser: ArgumentParser) {
        scanGitChanges = argumentParser.add(option: "--scan-git-changes",
                                            kind: Bool.self,
                                            usage: "Scans Git changed but not staged files for project files.")
    }
    
    func activate(arguments: ArgumentParser.Result, toolbox: Toolbox) throws {
        if arguments.get(scanGitChanges) ?? false {
            print("Scanning Git changes")
        }
    }
}

