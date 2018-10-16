
//  Created by Derek Clarkson on 4/10/18.

import Basic
import Foundation

public extension FileSystem {

    public var projectRoot: AbsolutePath {
        get {
            return localFileSystem.currentWorkingDirectory!
        }
        set {
            FileManager.default.changeCurrentDirectoryPath(newValue.asString)
        }
    }
}


