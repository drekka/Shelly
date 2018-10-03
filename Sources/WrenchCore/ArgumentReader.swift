
//  Created by Derek Clarkson on 3/10/18.

import Utility

public protocol ArgumentReader: class {
    var argumentClasses: [CommandArgument.Type] { get }
    var argumentHandlers: [String: CommandArgument] { get set }
    func setupArguments( inParser parser: ArgumentParser)
    func read(arguments: ArgumentParser.Result) throws
    func argumentHandler<T>() throws -> T where T: CommandArgument

}

public extension ArgumentReader {

    public func setupArguments(inParser parser: ArgumentParser) {
        self.argumentClasses.forEach { argumentDef in
            self.argumentHandlers[argumentDef.key] = argumentDef.init(argumentParser: parser)
        }
    }

    public func read(arguments: ArgumentParser.Result) throws {
        for var argument in argumentHandlers.values {
            try argument.read(arguments: arguments) }
    }

    public func argumentHandler<T>() throws -> T where T: CommandArgument {
        if let handler = argumentHandlers[T.key] as? T {
            return handler
        }
        throw WrenchError.argumentHandlerNotFound
    }
}
