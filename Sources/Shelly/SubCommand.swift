
//  Created by Derek Clarkson on 13/9/18.

import Basic
import Utility

public protocol SubCommand: ArgumentParserInitialiser, ResultMapper, ArgumentMapper {

    init()

    func configure(_ commandParser: ArgumentParser) throws -> String

    func configure(_ commandParser: ArgumentParser,
         subCommand: String,
         overview: String,
         argumentClasses: [Argument.Type]?) throws -> [String: Argument]

    func execute() throws
}

public extension SubCommand {

    public func configure(_ commandParser: ArgumentParser,
                   subCommand: String,
                   overview: String,
                   argumentClasses: [Argument.Type]? = nil) throws -> [String: Argument] {

        let subcommandParser = commandParser.add(subparser: subCommand,
                                                 overview: overview,
                                                 usage: argumentClasses?.syntax ?? "")

        return configure(subcommandParser, withArgumentClasses: argumentClasses)
    }
}
