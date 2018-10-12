
//  Created by Derek Clarkson on 13/9/18.

import Basic
import Utility

public protocol ParsedResultMapper: class {
    func map(_ parseResults: ArgumentParser.Result) throws
}

public protocol SubCommand: CommandArgumentParserInitialiser, ParsedResultMapper, CommandArgumentMapper {

    init()

    func configure(_ commandParser: ArgumentParser) throws -> String

    func configure(_ commandParser: ArgumentParser,
         subCommand: String,
         overview: String,
         argumentClasses: [CommandArgument.Type]) throws -> [String: CommandArgument]

    func execute() throws
}

public extension SubCommand {

    public func configure(_ commandParser: ArgumentParser,
                   subCommand: String,
                   overview: String,
                   argumentClasses: [CommandArgument.Type]) throws -> [String: CommandArgument] {

        let subcommandParser = commandParser.add(subparser: subCommand,
                                                 overview: overview,
                                                 usage: argumentClasses.syntax)

        return configure(subcommandParser, withArgumentClasses: argumentClasses)
    }
}
