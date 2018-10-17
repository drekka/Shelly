
//  Created by Derek Clarkson on 4/10/18.

import Basic
import Foundation

public extension FileSystem {

    public var currentDirectory: AbsolutePath {
        return localFileSystem.currentWorkingDirectory!
    }

    func setCurrentWorkingDirectory(_ workingDirectory: AbsolutePath) throws {
        guard FileManager.default.changeCurrentDirectoryPath(workingDirectory.asString) else {
            throw ShellyError.invalidCurrentDirectory
        }
    }
}


