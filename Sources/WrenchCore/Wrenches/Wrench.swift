
//  Created by Derek Clarkson on 13/9/18.

import Files
import Utility

public protocol Wrench {

    var subcommand: String { get }
    var overview: String { get }
    var argumentClasses: [CommandArgument.Type] { get }
    var commandArguments: [String: CommandArgument] { get set }

    var fileFilter: (SelectedFile) -> Bool { get }

    init()

    mutating func setup(subcommandParser: ArgumentParser)

    func read(arguments: ArgumentParser.Result) throws

    func execute(onFiles files: Set<SelectedFile>) throws
}

extension Wrench {

    mutating func setup(subcommandParser parser: ArgumentParser) {
        let arguments = self.argumentClasses.map { argumentDef -> (String, CommandArgument) in
            return (argumentDef.key, argumentDef.init(argumentParser: parser))
        }
        commandArguments = Dictionary(uniqueKeysWithValues: arguments)
    }

    func read(arguments: ArgumentParser.Result) throws {
        for var argument in commandArguments.values {
            try argument.read(arguments: arguments) }
    }
}
