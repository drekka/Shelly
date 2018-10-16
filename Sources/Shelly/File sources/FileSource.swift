
//  Created by Derek Clarkson on 13/9/18.

import Basic

public protocol FileSourceFactory {
    var fileSources: [FileSource]? { get }
}

public protocol FileSource {
    func getFiles() throws -> Set<RelativePath>
}
