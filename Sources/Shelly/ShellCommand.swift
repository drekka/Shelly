
//  Created by Derek Clarkson on 12/9/18.

import Foundation
import SwiftShell
import Utility
import Basic

open class ShellCommand: ArgumentParserInitialiser, ArgumentCollection {

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

    private let process: ((ArgumentCollection) throws -> Void)?
    private(set) public var arguments: [String : Argument] = [:]

    public init(command: String,
                overview: String,
                process: ((ArgumentCollection) throws -> Void)? = nil,
                subCommandClasses: [SubCommand.Type]? = nil,
                argumentClasses: [Argument.Type]? = nil) throws {

        self.process = process

        var usage: [String] = []
        if let argumentClasses = argumentClasses {
            usage.append(argumentClasses.syntax)
        }
        if subCommandClasses != nil {
            usage.append("sub-command")
        }
        usage.append("...")

        let parser = ArgumentParser(commandName: command + " [--help]",
                                    usage: usage.joined(separator: " "),
                                      overview: overview)

        arguments = configure(parser, withArgumentClasses: argumentClasses)
        let subCommands = try configure(parser, subCommandClasses: subCommandClasses)
        try run(usingParser: parser, subCommands: subCommands)
    }

    public func configure(_ parser: ArgumentParser, subCommandClasses: [SubCommand.Type]?) throws -> [String: SubCommand] {

        guard let classes = subCommandClasses else {
            return [:]
        }

        return Dictionary(uniqueKeysWithValues: try classes.map { subCommandDef in
            let subCommand = subCommandDef.init()
            return (try subCommand.configure(parser), subCommand)
        })
    }

    func run(usingParser parser: ArgumentParser, subCommands: [String: SubCommand]) throws {

        let parseResults = try parser.parse(Array(CommandLine.arguments.dropFirst()))

        // Parse the arguments.
        try map(parseResults)

        // Get the subpublic command and pass it the arguments.
        if let subCommandName = parseResults.subparser(parser) {
            guard let subCommand = subCommands[subCommandName] else {
                throw ShellyError.noSubcommandPassed
            }
            try subCommand.map(parseResults)
            try subCommand.execute()
            return
        }

        // No subcommand so run the passed process.
        try process?(self)
    }
}
