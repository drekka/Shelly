
//  Created by Derek Clarkson on 18/10/18.

import Basic
import Foundation
import Shelly

extension FileSystem {

    func switchToTmpDirectory() -> URL {
        let volumeURL = URL(fileURLWithPath: "/")
        let tmpDir = try! FileManager.default.url(for:.itemReplacementDirectory, in: .userDomainMask, appropriateFor: volumeURL, create: true)
        try! localFileSystem.setCurrentWorkingDirectory(tmpDir.path.resolve())
        return tmpDir
    }

    func create(testFile: String, inDirectory: String = ".") {
        let path: AbsolutePath = inDirectory.resolve()
        if !localFileSystem.exists(path) {
            try! localFileSystem.createDirectory(path)
        }
        try! localFileSystem.writeFileContents(path.appending(component:testFile), bytes: "")
    }
}
