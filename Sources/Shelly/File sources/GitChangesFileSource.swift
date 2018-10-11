
//  Created by Derek Clarkson on 13/9/18.

import Basic
import SwiftShell

struct GitChangesFileSource: FileSource {

    func getFiles() throws -> Set<RelativePath> {

        ShellCommand.log("Scanning Git staging area")

        let result = run(bash: "git diff --name-only | grep -v Carthage/Checkouts")
        if let error = result.error {
            throw error
        }

        let files = result.stdout.lines().compactMap { RelativePath($0) } // Note: Deleted files will generate a nil.
        return Set(files)
    }
}
