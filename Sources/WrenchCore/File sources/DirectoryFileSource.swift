
//  Created by Derek Clarkson on 14/9/18.

import Basic

struct DirectoryFileSource: FileSource {

    private let directory: RelativePath
    private let filter: ((RelativePath) -> Bool)?

    init(directory: RelativePath, filter: ((RelativePath) -> Bool)? = nil) {
        self.directory = directory
        self.filter = filter
    }

    func getFiles() throws -> Set<RelativePath> {

        let directoryPath = directory.absolutePath
        wrenchLog("Reading files from \(directoryPath.prettyPath())...")

        guard localFileSystem.exists(directoryPath) else {
            throw WrenchError.folderNotFound(directoryPath)
        }

        guard localFileSystem.isDirectory(directoryPath) else {
            throw WrenchError.notAFolder(directoryPath)
        }

        let files = try walk(directoryPath).map { $0.relative(to: projectRoot) }
        if let filter = filter {
            return Set(files.filter(filter))
        }
        return Set(files)
    }
}
