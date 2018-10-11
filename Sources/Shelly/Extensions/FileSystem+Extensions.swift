
//  Created by Derek Clarkson on 4/10/18.

import Basic
import Foundation

public var projectRoot: AbsolutePath = localFileSystem.currentWorkingDirectory!

public extension FileSystem {

    public func currentDirectory() throws -> AbsolutePath {
        if let currentDir = currentWorkingDirectory {
            return currentDir
        }
        throw ShellyError.invalidCurrentDirectory
    }

    static func set(projectDirectory: AbsolutePath) throws {
        FileManager.default.changeCurrentDirectoryPath(projectDirectory.asString)
        projectRoot = try localFileSystem.currentDirectory()
    }
}


