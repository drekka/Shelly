
//  Created by Derek Clarkson on 13/9/18.

import Basic

protocol FileSource {
    func getFiles() throws -> Set<RelativePath>
}
