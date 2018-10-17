
//  Created by Derek Clarkson on 17/10/18.

import Utility

public protocol ArgumentCollection: ArgumentMapable {

    var arguments: [String: Argument] { get }

    /**
     Retrieves a specific argument from the arguments map using the expected
     types key to find it.

     This assumes that the expected return type is the same as the type stored in the
     map.

     - Returns: The expected argument.
     - Throws: An error if there is not such type in the map.
     */
    func getArgument<T>() throws -> T where T: Argument
}

public extension ArgumentCollection {

    public func map(_ parseResults: ArgumentParser.Result) throws {
        try arguments.values.forEach { argument in
            try argument.map(parseResults)
        }
    }

    public func getArgument<T>() throws -> T where T: Argument {
        if let handler = arguments[T.key] as? T {
            return handler
        }
        throw ShellyError.argumentNotFound
    }
}
