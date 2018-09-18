
//  Created by Derek Clarkson on 17/9/18.

import Foundation
import Files
import SwiftShell

struct PipeFileSource: FileSource {

    func getFiles() throws -> Set<SelectedFile> {
        print("Reading files from piped input ...")
        let pipedFiles = main.stdin
        return try Set(pipedFiles.lines().map { try SelectedFile(file: $0) })
    }
}
