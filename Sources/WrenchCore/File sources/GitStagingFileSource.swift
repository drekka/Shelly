
//  Created by Derek Clarkson on 13/9/18.

import Foundation
import SwiftShell
import Files

struct GitStagingFileSource: FileSource {
    
    func getFiles() throws -> Set<SelectedFile> {

        print("Scanning Git staging area")

        let result = run(bash: "git diff --name-only --cached | grep -v Carthage/Checkouts")
        if let error = result.error {
                throw error
        }
        
        let files = result.stdout.lines().compactMap { try? SelectedFile(file: $0) } // Note: Deleted files will generate a nil.
        return Set(files)
    }
}

