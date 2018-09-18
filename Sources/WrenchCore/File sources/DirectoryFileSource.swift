
//  Created by Derek Clarkson on 14/9/18.

import Foundation
import Files
import Utility

struct DirectoryFileSource: FileSource {
    
    private let directory: Folder
    
    init(directory: Folder) {
        self.directory = directory
    }
    
    func getFiles() throws -> Set<SelectedFile> {
        print("Adding files from \(directory)")
        let files = directory.makeFileSequence(recursive: true, includeHidden: false).map { SelectedFile(file: $0) }
        return Set(files)
    }
}
