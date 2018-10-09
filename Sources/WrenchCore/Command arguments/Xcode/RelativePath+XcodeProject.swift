
//  Created by Derek Clarkson on 9/10/18.

import Basic
import xcodeproj

public extension RelativePath {
    
    func loadProject() throws -> XcodeProj {

        guard self.extension == "xcodeproj" else {
            throw WrenchError.incorrectFile("'\(self.asString)' should be an xcode project file (directory), for example MyProject.xcodeproj")
        }

        return try XcodeProj(path: self.absolutePath)
    }
}

