
//  Created by Derek Clarkson on 4/10/18.

import Basic
import Utility
import Foundation

/// An argument representing a relative path (file / directory).
///
/// This is based on the PathArgument class which maps AbsolutePath instances.

public struct LocalPathArgument: ArgumentKind {

    private let rawPath: String

    public var absolutePath: AbsolutePath {
        return rawPath.resolve()
    }

    public var relativePath: RelativePath {
        return rawPath.resolve()
    }

    /// Default intializer.
    public init(argument: String) throws {
        rawPath = argument
    }

    /// Path completion.
    public static var completion: ShellCompletion = .filename
}
