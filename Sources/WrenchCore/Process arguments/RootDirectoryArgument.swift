
//  Created by Derek Clarkson on 18/9/18.

import Utility
import Files
import Foundation

struct RootDirectoryArgument: CommandArgument {
    
    static let argumentSyntax: String? = "<--project-dir dir>"
    
    private let rootDir: OptionArgument<String>

    init(argumentParser: ArgumentParser) {
        rootDir = argumentParser.add(option: "--project-dir",
                                     kind: String.self,
                                     usage: "Base directory of the project. Defaults to the current directory.")
    }
    
    func activate(arguments: ArgumentParser.Result, toolbox: Toolbox) throws {
        if let rootDir = arguments.get(rootDir) {
            guard FileManager.default.changeCurrentDirectoryPath(rootDir) else {
                print("Changing directory to \(rootDir) failed, does the directory exist?")
                exit(1)
            }
            print("Switched to directory \(rootDir)")
        }
    }
}

