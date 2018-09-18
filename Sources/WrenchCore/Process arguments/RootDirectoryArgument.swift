
//  Created by Derek Clarkson on 18/9/18.

import Utility
import Files
import Foundation

struct RootDirectoryArgument: CommandArgument {
    
    private let rootDir: OptionArgument<String>

    init(argumentParser: ArgumentParser) {
        rootDir = argumentParser.add(option: "--root-dir",
                                     kind: String.self,
                                     usage: "Root directory of the project. Git aware wrenches will expect to find a git repository in this directory.")
    }
    
    func activate(arguments: ArgumentParser.Result, toolbox: Toolbox) throws {
        if let rootDir = arguments.get(rootDir) {
            guard FileManager.default.changeCurrentDirectoryPath(rootDir) else {
                print("Changing root directory to \(rootDir) failed, does the directory exist?")
                exit(1)
            }
            print("Switched to directory \(rootDir)")
        }
    }
}

