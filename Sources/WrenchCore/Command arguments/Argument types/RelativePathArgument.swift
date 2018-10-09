
//  Created by Derek Clarkson on 4/10/18.

import Basic
import Utility

/// An argument representing a relative path (file / directory).
///
struct RelativePathArgument: ArgumentKind {

    let path: RelativePath

    init(argument: String) throws {
        path = try RelativePath(validating: argument)
    }

    static var completion: ShellCompletion = .filename
}
