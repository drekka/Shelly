
//  Created by Derek Clarkson on 4/10/18.

import Basic
import Utility

/// An argument representing a relative path (file / directory).
///
/// This is based on the PathArgument class which maps AbsolutePath instances.

struct RelativePathArgument: ArgumentKind {

    /// The path as read from the argument.
    let path: RelativePath

    /// Default intializer.
    init(argument: String) throws {
        path = try RelativePath(validating: argument)
    }

    /// Path completion.
    static var completion: ShellCompletion = .filename
}
