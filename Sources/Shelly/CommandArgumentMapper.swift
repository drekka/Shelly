
//  Created by Derek Clarkson on 3/10/18.

import Utility

public protocol CommandArgumentMapper {

    func map(_ parseResults: ArgumentParser.Result, intoArguments arguments: [String: CommandArgument]) throws

    /**
     Retrieves a specific argument from the arguments map using the expected
     types key to find it.

     This assumes that the expected return type is the same as the type stored in the
     map.

     - Returns: The expected argument.
     - Throws: An error if there is not such type in the map.
     */
    func getArgument<T>(fromArguments arguments: [String: CommandArgument]) throws -> T where T: CommandArgument
}

extension CommandArgumentMapper {

    public func map(_ parseResults: ArgumentParser.Result, intoArguments arguments: [String: CommandArgument]) throws {
        try arguments.values.forEach { argument in
            try argument.map(parseResults)
        }
    }

    public func getArgument<T>(fromArguments arguments: [String: CommandArgument]) throws -> T where T: CommandArgument {
        if let handler = arguments[T.key] as? T {
            return handler
        }
        throw ShellyError.argumentNotFound
    }
}

