
//  Created by Derek Clarkson on 12/9/18.

import Foundation
import SwiftShell
import Utility
import Basic

public class ShellCommand: ProcessArgumentReader {

    public static var commandName = "shell-command"
    public static var commandOverview = ""
    public static var subCommandClasses: [SubCommand.Type] = []

    static var verbose: Bool = false

    public static func log(_ message: String, _ args: CVarArg...) {
        main.stdout.print(String(format: message, args))
    }

    public static func logError(_ message: String, _ args: CVarArg...) {
        main.stderror.print("Error !")
        main.stderror.print(String(format: message, args))
        main.stderror.print("Use '\(ShellCommand.commandName) --help' for command syntax help.")
        main.stderror.print("")
    }

    public static func verboseLog(_ message: String, _ args: CVarArg...) {
        guard verbose else { return }
        main.stdout.print("🔦 " + String(format: message, args))
    }


    public var argumentClasses: [CommandArgument.Type] = [
        VerboseArgument.self,
        RootDirectoryArgument.self,
        ]

    public var arguments: [String : CommandArgument] = [:]

    private let rootParser: ArgumentParser
    private var subCommands: [String: SubCommand] = [:]


    public init() throws {
        rootParser = ArgumentParser(commandName: ShellCommand.commandName + " [--help]",
                                      usage: argumentClasses.syntax + " sub-command ...",
                                      overview: ShellCommand.commandOverview)
        setup()
        try run()
    }

    func setup() {

        self.setup(rootParser)

        type(of: self).subCommandClasses.forEach { subCommandDef in
            let subCommand = subCommandDef.init()
            let subcommandParser = rootParser.add(subparser: subCommand.subcommand,
                                                    overview: subCommand.overview,
                                                    usage: subCommand.argumentClasses.syntax)
            subCommand.setup(subcommandParser)
            subCommands[subCommand.subcommand] = subCommand
        }
    }

    func run() throws {

        let arguments = try readProcessArguments(withParser: rootParser)

        // Get the subcommand and pass it the arguments.
        guard let subCommandName = arguments.subparser(rootParser),
            let subCommand = subCommands[subCommandName] else {
                throw ShellyError.noSubcommandPassed
        }
        try subCommand.parse(arguments: arguments)

        try subCommand.execute()
    }
}
