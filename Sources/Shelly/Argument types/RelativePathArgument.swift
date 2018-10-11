
//  Created by Derek Clarkson on 4/10/18.

import Basic
import Utility

/// An argument representing a relative path (file / directory).
///
/// This is based on the PathArgument class which maps AbsolutePath instances.

public struct RelativePathArgument: ArgumentKind {

    /// The path as read from the argument.
    public let path: RelativePath

    /// Default intializer.
    public init(argument: String) throws {
        path = try RelativePath(validating: argument)
    }

    /// Path completion.
    public static var completion: ShellCompletion = .filename
}
