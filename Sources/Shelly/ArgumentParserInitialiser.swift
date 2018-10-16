
//  Created by Derek Clarkson on 11/10/18.

import Utility

/**
 ProcessArgumentConfigurers are responsible for setting up command line arguments.
 */
public protocol ArgumentParserInitialiser: class {

    /**
     Sets up the passed ArgumentParser.

     In this method you should set up the relevant arguments.

     - Parameter parser: The parser to be setup.
     - Parameter argumentClasses: An array of classes that defines the valid arguments.
     - Returns: A map of keys to arguments.
     */
    func configure(_ parser: ArgumentParser, withArgumentClasses argumentClasses: [Argument.Type]?) -> [String: Argument]

}

/// Default implementations for the methods.
public extension ArgumentParserInitialiser {

    public func configure(_ parser: ArgumentParser, withArgumentClasses argumentClasses: [Argument.Type]?) -> [String: Argument] {

        guard let classes = argumentClasses else {
            return [:]
        }

        return Dictionary(uniqueKeysWithValues: classes.map { ($0.key, $0.init(argumentParser: parser)) })
    }

}
