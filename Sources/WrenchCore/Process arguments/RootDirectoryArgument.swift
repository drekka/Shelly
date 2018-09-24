
//  Created by Derek Clarkson on 18/9/18.

import Foundation
import SwiftShell
import Utility

struct RootDirectoryArgument: CommandArgument {
    static let argumentSyntax: String? = "[--project-dir <dir>]"

    private let rootDir: OptionArgument<String>

    init(argumentParser: ArgumentParser) {
        rootDir = argumentParser.add(option: "--project-dir",
                                     kind: String.self,
                                     usage: "Base directory of the project. Defaults to the current directory.")
    }

    func activate(arguments: ArgumentParser.Result, toolbox _: Toolbox) throws {
        if let rootDir = arguments.get(rootDir) {
            guard Files.changeCurrentDirectoryPath(rootDir) else {
                wrenchLogError("Changing directory to \(rootDir) failed, does the directory exist?")
                exit(1)
            }
            wrenchLog("Switched to directory \(rootDir)")
        }
    }
}
