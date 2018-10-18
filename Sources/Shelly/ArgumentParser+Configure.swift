
//  Created by Derek Clarkson on 11/10/18.

import Utility

/// Default implementations for the methods.
extension ArgumentParser {

    public func configure(withArgumentClasses argumentClasses: [Argument.Type]?) -> [String: Argument] {

        guard let classes = argumentClasses else {
            return [:]
        }

        return Dictionary(uniqueKeysWithValues: classes.map { ($0.key, $0.init(argumentParser: self)) })
    }

    func configure(withSubCommandClasses subCommandClasses: [SubCommand.Type]?) throws -> [String: SubCommand] {

        guard let classes = subCommandClasses else {
            return [:]
        }

        return Dictionary(uniqueKeysWithValues: try classes.map { subCommandDef in
            let subCommand = subCommandDef.init()
            return (try subCommand.configure(self), subCommand)
            })
    }
}
