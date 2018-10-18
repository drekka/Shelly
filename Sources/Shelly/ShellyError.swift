
//  Created by Derek Clarkson on 18/9/18.

import Basic

public enum ShellyError: Error, CustomStringConvertible {

    case invalidCurrentDirectory

    case missingArgument(String)

    case illegalArgument(String, String)

    case argumentNotFound

    case noSubcommandPassed

    case incorrectFile(String)

    case folderNotFound(AbsolutePath)

    case notAFolder(AbsolutePath)


    public var description: String {
        switch self {

        case let .missingArgument(argument):
            return "Missing argument. '\(argument)' is required."

        case .invalidCurrentDirectory:
            return "Unable to obtain the current working directory."

        case .argumentNotFound:
            return "Argument handler not found."

        case .noSubcommandPassed:
            return "No sub-command found. Please use '--help' to see a list of all valid subcommands."

        case let .incorrectFile(message):
            return "Incorrect file passed: \(message)"

        case let .notAFolder(filePath):
            return "Specified path: \(filePath.prettyPath()) - is not a valid folder."

        case let .folderNotFound(filePath):
            return "Folder not found: \(filePath.prettyPath())"

        case let .illegalArgument(arg, unless):
            return "Illegal argument: \(arg) is not allowed unless \(unless)"
        }
    }
}
