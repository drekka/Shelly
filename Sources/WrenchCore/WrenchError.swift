
//  Created by Derek Clarkson on 18/9/18.

import Foundation

enum WrenchError: Error, CustomStringConvertible {
    case folderNotFound(String)

    case unknownArgument(String)

    case illegalArgument(String, String)

    var description: String {
        switch self {
        case let .folderNotFound(filePath):
            return "Folder not found: \(filePath)"

        case let .unknownArgument(arg):
            return "Unknown argument: \(arg)"

        case let .illegalArgument(arg, unless):
            return "Illegal argument: \(arg) is not allowed unless \(unless)"
        }
    }
}
