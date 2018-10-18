
//  Created by Derek Clarkson on 18/9/18.

import Utility
import Basic
import SwiftShell
import Foundation

public class ProjectDirectoryArgument: Argument {

    public static let argumentSyntax = "[--project-dir <dir>]"

    private let projectDir: OptionArgument<LocalPathArgument>

    public required init(argumentParser: ArgumentParser) {
        projectDir = argumentParser.add(option: "--project-dir",
                                     kind: LocalPathArgument.self,
                                     usage: "Base directory of the project. Defaults to the current directory.")
    }

    public func map(_ parseResults: ArgumentParser.Result) throws {
        if let rootDir = parseResults.get(projectDir) {
            try localFileSystem.setCurrentWorkingDirectory(rootDir.absolutePath)
            ShellCommand.log("Switched to directory \(localFileSystem.currentDirectory.asString)")
        }
    }
}
