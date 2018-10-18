
//  Created by Derek Clarkson on 11/10/18.

import Basic

public protocol FileSourceReader {
    func argumentFiles(usingFilter filter: ((RelativePath) -> Bool)?) throws -> Set<RelativePath>
}

public extension FileSourceReader where Self: ArgumentCollection {

    public func argumentFiles(usingFilter filter: ((RelativePath) -> Bool)? = nil) throws -> Set<RelativePath> {

        var sourceFiles = Set<RelativePath>()
        try arguments.values.forEach { argument in
            if let fileSourceFactory = argument as? FileSourceFactory, let fileSources = fileSourceFactory.fileSources {
                sourceFiles = sourceFiles.union(try fileSources.flatMap { try $0.getFiles() })
            }
        }

        if let filter = filter {
            return sourceFiles.filter(filter)
        }

        return sourceFiles
    }
}
