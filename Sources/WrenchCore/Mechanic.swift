
//  Created by Derek Clarkson on 12/9/18.

import Files
import Foundation
import SwiftShell
import Utility

public class Mechanic: ArgumentReader {

    public var argumentClasses: [CommandArgument.Type] = [
        RootDirectoryArgument.self,
        ]

    public var argumentHandlers: [String : CommandArgument] = [:]

    private let wrenchParser: ArgumentParser
    private var wrenches: [String: Wrench] = [:]

    private let wrenchClasses: [Wrench.Type] = [
        XcodeProjectSortWrench.self,
        XcodeProjectFileCheckWrench.self,
        ]

    public init() {
        wrenchParser = ArgumentParser(commandName: "wrench [--help]",
                                      usage: argumentClasses.syntax + " command <command-arguments> ...",
                                      overview: "Useful tools for keeping your project in tip-top shape.")
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

        // Source the files to process.
        var sourceFiles = Set<SelectedFile>()
        try wrench.argumentHandlers.values.forEach { argument in
            if let fileSourceFactory = argument as? FileSourceFactory, let fileSources = fileSourceFactory.fileSources {
                sourceFiles = sourceFiles.union(try fileSources.flatMap { try $0.getFiles() })
            }
        }

        try wrench.execute(onFiles: sourceFiles.filter(wrench.fileFilter))
    }
}
