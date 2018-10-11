
//  Created by Derek Clarkson on 11/10/18.

import Basic

public protocol FileProcessor {
    var fileFilter: ((RelativePath) -> Bool)? { get }
    func files() throws -> Set<RelativePath>
}

public extension FileProcessor where Self: SubCommand {

    func files() throws -> Set<RelativePath> {

        var sourceFiles = Set<RelativePath>()
        try self.arguments.values.forEach { argument in
            if let fileSourceFactory = argument as? FileSourceFactory, let fileSources = fileSourceFactory.fileSources {
                sourceFiles = sourceFiles.union(try fileSources.flatMap { try $0.getFiles() })
            }
        }

        if let filter = fileFilter {
            return sourceFiles.filter(filter)
        }

        return sourceFiles
    }
}
