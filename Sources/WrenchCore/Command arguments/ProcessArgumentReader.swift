
//  Created by Derek Clarkson on 3/10/18.

import Utility

protocol ProcessArgumentParser {
    func parse(arguments: ArgumentParser.Result) throws
}

/**
 ProcessArgumentReaders are responsible for setting up,
reading and understanding command line arguments.

 The associated extension provides the bulk of the implementations for this protocol
 so the only things that need to be coded are the variables and `setup(_:)` function.
 */
protocol ProcessArgumentReader: class, ProcessArgumentParser {

    /// A list of classes that represent process arguments.
    var argumentClasses: [CommandArgument.Type] { get }

    /// A map of argument keys to instances of the process arguments.
    /// This is used to retrieve the relevant arguments in the wrenches.
    var arguments: [String: CommandArgument] { get set }


    /**
     Sets up the passed ArgumentParser.

     In this method you should set up the relevant arguments.

    - Parameter parser: The parser to be setup.
     */
    func setup(_ parser: ArgumentParser)

    /**
     Reads the process's arguments.

     Usually this is the start of the processing of command line arguments.
     The defual implementation of this function reads the command line arguments and
     calls the `ArgumentParser`'s `parse(arguments:)` method.

     - Parameter parser: The ArgumentParser to parse the arguments with.
    */
    func readProcessArguments(withParser parser: ArgumentParser) throws -> ArgumentParser.Result


    /**
     Retrieves a specific argument from the arguments map using the expected
     types key to find it.

     This assumes that the expected return type is the same as the type stored in the
     map.

     - Returns: The expected argument.
     - Throws: An error if there is not such type in the map.
    */
    func getArgument<T>() throws -> T where T: CommandArgument
}

/// Default implementations for the methods.
extension ProcessArgumentReader {

    func readProcessArguments(withParser parser: ArgumentParser) throws -> ArgumentParser.Result {
        let parseResult = try parser.parse(Array(CommandLine.arguments.dropFirst()))
        try parse(arguments: parseResult)
        return parseResult
    }

    func setup(_ parser: ArgumentParser) {
        argumentClasses.forEach { argumentDef in
            arguments[argumentDef.key] = argumentDef.init(argumentParser: parser)
        }
    }

    func parse(arguments: ArgumentParser.Result) throws {
        try self.arguments.values.forEach { argument in
            try argument.parse(arguments: arguments)
        }
    }

    func getArgument<T>() throws -> T where T: CommandArgument {
        if let handler = arguments[T.key] as? T {
            return handler
        }
        throw WrenchError.argumentNotFound
    }
}
