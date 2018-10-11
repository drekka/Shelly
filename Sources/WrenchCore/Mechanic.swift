
//  Created by Derek Clarkson on 12/9/18.

import Foundation
import SwiftShell
import Utility
import Basic

public class Mechanic: ProcessArgumentReader {

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

        self.setup(wrenchParser)

        wrenchClasses.forEach { wrenchDef in
            let wrench = wrenchDef.init()
            let subcommandParser = wrenchParser.add(subparser: wrench.subcommand,
                                                    overview: wrench.overview,
                                                    usage: wrench.argumentClasses.syntax)
            wrench.setup(subcommandParser)
            wrenches[wrench.subcommand] = wrench
        }
    }

    public func run() throws {

        let arguments = try readProcessArguments(withParser: wrenchParser)

        // Get the subcommand and pass it the arguments.
        guard let subcommand = arguments.subparser(wrenchParser),
            let wrench = wrenches[subcommand] else {
                throw WrenchError.noSubcommandPassed
        }
        try wrench.parse(arguments: arguments)

        try wrench.execute()
    }
}
