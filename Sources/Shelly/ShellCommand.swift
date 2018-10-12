
//  Created by Derek Clarkson on 12/9/18.

import Foundation
import SwiftShell
import Utility
import Basic

open class ShellCommand: CommandArgumentParserInitialiser, CommandArgumentMapper {

    static var verbose: Bool = false

    public static func log(_ message: String, _ args: CVarArg...) {
        main.stdout.print(String(format: message, args))
    }

    public static func logError(_ message: String, _ args: CVarArg...) {
        main.stderror.print("Error !")
        main.stderror.print(String(format: message, args))
        main.stderror.print("Use '--help' for command syntax help.")
        main.stderror.print("")
    }

    public static func verboseLog(_ message: String, _ args: CVarArg...) {
        guard verbose else { return }
        main.stdout.print("🔦 " + String(format: message, args))
    }

    public init(command: String,
                overview: String,
                subCommandClasses: [SubCommand.Type],
                argumentClasses: [CommandArgument.Type]) throws {
        let parser = ArgumentParser(commandName: command + " [--help]",
                                      usage: argumentClasses.syntax + " sub-command ...",
                                      overview: overview)

        let arguments = self.configure(parser, withArgumentClasses: argumentClasses)
        let subCommands = try configure(parser, subCommandClasses: subCommandClasses)
        try run(usingParser: parser, subCommands: subCommands, arguments: arguments)
    }

    public func configure(_ parser: ArgumentParser, subCommandClasses: [SubCommand.Type]) throws -> [String: SubCommand] {
        return Dictionary(uniqueKeysWithValues: try subCommandClasses.map { subCommandDef in
            let subCommand = subCommandDef.init()
            return (try subCommand.configure(parser), subCommand)
        })
    }

    func run(usingParser parser: ArgumentParser, subCommands: [String: SubCommand], arguments: [String: CommandArgument]) throws {

        let parseResults = try parser.parse(Array(CommandLine.arguments.dropFirst()))

        // Parse the arguments.
        try map(parseResults, intoArguments: arguments)

        // Get the subpublic command and pass it the arguments.
        guard let subCommandName = parseResults.subparser(parser), let subCommand = subCommands[subCommandName] else {
                throw ShellyError.noSubcommandPassed
        }
        try subCommand.map(parseResults)

        try subCommand.execute()
    }
}
