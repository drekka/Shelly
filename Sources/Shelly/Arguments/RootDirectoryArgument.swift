
//  Created by Derek Clarkson on 18/9/18.

import Utility
import Basic
import SwiftShell
import Foundation

public class RootDirectoryArgument: Argument {

    public static let argumentSyntax = "[--project-dir <dir>]"

    private let rootDir: OptionArgument<PathArgument>

    public required init(argumentParser: ArgumentParser) {
        rootDir = argumentParser.add(option: "--project-dir",
                                     kind: PathArgument.self,
                                     usage: "Base directory of the project. Defaults to the current directory.")
    }

    public func map(_ parseResults: ArgumentParser.Result) throws {
        if let rootDir = parseResults.get(rootDir) {
            let dir = rootDir.path.asString
            guard Files.changeCurrentDirectoryPath(dir) else {
                ShellCommand.logError("Changing directory to \(dir) failed, does the directory exist?")
                exit(1)
            }
            ShellCommand.log("Switched to directory \(dir)")
        }

    }
}
