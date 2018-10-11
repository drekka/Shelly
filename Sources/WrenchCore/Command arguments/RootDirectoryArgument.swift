
//  Created by Derek Clarkson on 18/9/18.

import Utility
import Basic
import SwiftShell
import Foundation

class RootDirectoryArgument: CommandArgument {

    static let argumentSyntax = "[--project-dir <dir>]"

    private let rootDir: OptionArgument<PathArgument>

    required init(argumentParser: ArgumentParser) {
        rootDir = argumentParser.add(option: "--project-dir",
                                     kind: PathArgument.self,
                                     usage: "Base directory of the project. Defaults to the current directory.")
    }

    func parse(arguments: ArgumentParser.Result) throws {
        if let rootDir = arguments.get(rootDir) {
            let dir = rootDir.path.asString
            guard Files.changeCurrentDirectoryPath(dir) else {
                wrenchLogError("Changing directory to \(dir) failed, does the directory exist?")
                exit(1)
            }
            wrenchLog("Switched to directory \(dir)")
        }

    }
}
