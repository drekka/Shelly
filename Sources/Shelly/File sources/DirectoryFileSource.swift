
//  Created by Derek Clarkson on 14/9/18.

import Basic

public struct DirectoryFileSource: FileSource {

    private let directory: RelativePath
    private let filter: ((RelativePath) -> Bool)?

    public init(directory: RelativePath, filter: ((RelativePath) -> Bool)? = nil) {
        self.directory = directory
        self.filter = filter
    }

    public func getFiles() throws -> Set<RelativePath> {

        let directoryPath = directory.absolutePath
        ShellCommand.verboseLog("Reading files from \(directoryPath.prettyPath())...")

        guard localFileSystem.exists(directoryPath) else {
            throw ShellyError.folderNotFound(directoryPath)
        }

        guard localFileSystem.isDirectory(directoryPath) else {
            throw ShellyError.notAFolder(directoryPath)
        }

        let files = try walk(directoryPath).map { $0.relative(to: localFileSystem.currentDirectory) }
        if let filter = filter {
            return Set(files.filter(filter))
        }
        return Set(files)
    }
}
