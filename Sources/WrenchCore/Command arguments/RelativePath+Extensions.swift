
//  Created by Derek Clarkson on 9/10/18.

import Basic

extension RelativePath {
    var absolutePath: AbsolutePath {
        return AbsolutePath(projectRoot, self)
    }
}
