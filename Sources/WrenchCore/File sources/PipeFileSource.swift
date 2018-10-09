
//  Created by Derek Clarkson on 17/9/18.

import Basic
import SwiftShell

struct PipeFileSource: FileSource {
    func getFiles() throws -> Set<RelativePath> {
        wrenchLog("Reading files from piped input ...")
        let pipedFiles = main.stdin
        return Set(pipedFiles.lines().map { RelativePath(String($0.dropFirst())) })
    }
}
