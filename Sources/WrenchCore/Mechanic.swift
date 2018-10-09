
//  Created by Derek Clarkson on 12/9/18.

import Foundation
import SwiftShell
import Utility
import Basic

public class Mechanic: ArgumentReader {

    var argumentClasses: [CommandArgument.Type] = [
        VerboseArgument.self,
        RootDirectoryArgument.self,
        ]

    var arguments: [String : CommandArgument] = [:]

    private let wrenchParser: ArgumentParser
    private var wrenches: [String: Wrench] = [:]

    private let wrenchClasses: [Wrench.Type] = [
        XcodeProjectSortWrench.self,
        XcodeProjectLostFilesWrench.self,
        ]

    public init() {
        wrenchParser = ArgumentParser(commandName: "wrench [--help]",
                                      usage: argumentClasses.syntax + " sub-command ...",
                                      overview: "Useful tools for keeping your project in tip-top shape. Use 'wrench subcommand --help' for details on each subcommand.")
    }

    public func setup() {

        self.setupArguments(inParser: wrenchParser)

        wrenchClasses.forEach { wrenchDef in
            let wrench = wrenchDef.init()
            let subcommandParser = wrenchParser.add(subparser: wrench.subcommand,
                                                    overview: wrench.overview,
                                                    usage: wrench.argumentClasses.syntax)
            wrench.setupArguments(inParser: subcommandParser)
            wrenches[wrench.subcommand] = wrench
        }
    }

    public func run() throws {

        let arguments = try wrenchParser.parse(Array(CommandLine.arguments.dropFirst()))

        // Process the global arguments.
        try self.read(arguments: arguments)

        // Get the subcommand and pass it the arguments.
        guard let subcommand = arguments.subparser(wrenchParser),
            let wrench = wrenches[subcommand] else {
                throw WrenchError.noSubcommandPassed
        }
        try wrench.read(arguments: arguments)

        try wrench.execute()
    }
}
