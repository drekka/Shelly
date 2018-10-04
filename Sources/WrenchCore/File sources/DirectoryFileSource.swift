
//  Created by Derek Clarkson on 14/9/18.

import Files
import Foundation
import Utility
import Basic

struct DirectoryFileSource: FileSource {
    private let directory: Folder

    init(directory: AbsolutePath) {
        self.directory = directory.
    }

    init(directory: Folder) {
        self.directory = directory
    }

    func getFiles() throws -> Set<SelectedFile> {
        wrenchLog("Reading files from \(directory)...")
        let files = directory.makeFileSequence(recursive: true, includeHidden: false).map { SelectedFile(file: $0) }
        return Set(files)
    }
}
