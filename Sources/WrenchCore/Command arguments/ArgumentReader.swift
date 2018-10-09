
//  Created by Derek Clarkson on 3/10/18.

import Utility

protocol ArgumentReader: class {
    var argumentClasses: [CommandArgument.Type] { get }
    var arguments: [String: CommandArgument] { get set }
    func setupArguments( inParser parser: ArgumentParser)
    func read(arguments: ArgumentParser.Result) throws
    func retrieveArgument<T>() throws -> T where T: CommandArgument
}

extension ArgumentReader {

    func setupArguments(inParser parser: ArgumentParser) {
        self.argumentClasses.forEach { argumentDef in
            self.arguments[argumentDef.key] = argumentDef.init(argumentParser: parser)
        }
    }

    func read(arguments: ArgumentParser.Result) throws {
        for argument in self.arguments.values {
            try argument.read(arguments: arguments) }
    }

    func retrieveArgument<T>() throws -> T where T: CommandArgument {
        if let handler = arguments[T.key] as? T {
            return handler
        }
        throw WrenchError.argumentHandlerNotFound
    }
}
