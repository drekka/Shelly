
//  Created by Derek Clarkson on 18/9/18.

import Foundation
import SwiftShell
import Utility

struct RootDirectoryArgument: CommandArgument {

    static let argumentSyntax: String? = "[--project-dir <dir>]"

    private let rootDir: OptionArgument<PathArgument>

    init(argumentParser: ArgumentParser) {
        rootDir = argumentParser.add(option: "--project-dir",
                                     kind: PathArgument.self,
                                     usage: "Base directory of the project. Defaults to the current directory.")
    }

    func read(arguments: ArgumentParser.Result) throws {
        if let rootDir = arguments.get(rootDir) {
            guard Files.changeCurrentDirectoryPath(rootDir.path.asString) else {
                wrenchLogError("Changing directory to \(rootDir) failed, does the directory exist?")
                exit(1)
            }
            wrenchLog("Switched to directory \(rootDir)")
        }
    }
}
