
//  Created by Derek Clarkson on 4/10/18.

import Basic
import Foundation

var projectRoot: AbsolutePath = localFileSystem.currentWorkingDirectory!

extension FileSystem {

    func currentDirectory() throws -> AbsolutePath {
        if let currentDir = currentWorkingDirectory {
            return currentDir
        }
        throw WrenchError.invalidCurrentDirectory
    }

    static func set(projectDirectory: AbsolutePath) throws {
        FileManager.default.changeCurrentDirectoryPath(projectDirectory.asString)
        projectRoot = try localFileSystem.currentDirectory()
    }
}


