
//  Created by Derek Clarkson on 18/9/18.

import Basic

enum WrenchError: Error, CustomStringConvertible {

    case missingArgument(String)

    case invalidCurrentDirectory

    case argumentHandlerNotFound

    case noSubcommandPassed

    case incorrectFile(String)

    case folderNotFound(AbsolutePath)

    case notAFolder(AbsolutePath)

    case unknownArgument(String)

    case illegalArgument(String, String)

    var description: String {
        switch self {

        case let .missingArgument(argument):
            return "Missing argument. '\(argument)' is required."

        case .invalidCurrentDirectory:
            return "Unable to obtain the current working directory."

        case .argumentHandlerNotFound:
            return "Argument handler not found."

        case .noSubcommandPassed:
            return "No sub-command found. Please use 'wrench --help' to see a list of all valid subcommands."

        case let .incorrectFile(message):
            return "Incorrect file passed: \(message)"

        case let .notAFolder(filePath):
            return "Specified path: \(filePath.prettyPath()) - is not a valid folder."

        case let .folderNotFound(filePath):
            return "Folder not found: \(filePath.prettyPath())"

        case let .unknownArgument(arg):
            return "Unknown argument: \(arg)"

        case let .illegalArgument(arg, unless):
            return "Illegal argument: \(arg) is not allowed unless \(unless)"
        }
    }
}
