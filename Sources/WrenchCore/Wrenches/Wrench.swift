
//  Created by Derek Clarkson on 13/9/18.

import Basic

protocol Wrench: ArgumentReader {

    var subcommand: String { get }
    var overview: String { get }

    init()
    func execute() throws
}

protocol FileProcessor {
    var fileFilter: ((RelativePath) -> Bool)? { get }
    func files() throws -> Set<RelativePath>
}

extension FileProcessor where Self: Wrench {

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
