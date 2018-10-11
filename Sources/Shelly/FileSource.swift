
//  Created by Derek Clarkson on 13/9/18.

import Basic

public protocol FileSource {
    func getFiles() throws -> Set<RelativePath>
}
