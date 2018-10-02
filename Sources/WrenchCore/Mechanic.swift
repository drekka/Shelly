
//  Created by Derek Clarkson on 12/9/18.

import Files
import Foundation
import SwiftShell
import Utility

public func wrenchLog(_ message: String) {
    main.stdout.print(message)
}

public func wrenchLogError(_ message: String) {
    main.stderror.print("Error !")
    main.stderror.print(message)
    main.stderror.print("Use 'wrench --help' for command syntax help.")
    main.stderror.print("")
}

public class Mechanic {

    private let wrenchParser: ArgumentParser
    private var wrenches: [String: Wrench] = [:]

    public init() {

        let globalArgumentClasses: [CommandArgument.Type] = [
            RootDirectoryArgument.self,
            ]

        wrenchParser = ArgumentParser(commandName: "wrench [--help]",
                                      usage: globalArgumentClasses.syntax + " command <command-arguments> ...",
                                      overview: "Useful tools for keeping your project in tip-top shape.")

        let wrenchClasses: [Wrench.Type] = [
            XcodeProjectSortWrench.self,
            XcodeProjectFileCheckWrench.self,
            ]

        let subcommandMap = wrenchClasses.map { wrenchDef -> (String, Wrench) in
            var wrench = wrenchDef.init()
            let subcommandParser = wrenchParser.add(subparser: wrench.subcommand,
                                                    overview: wrench.overview,
                                                    usage: wrench.argumentClasses.syntax)
            wrench.setup(subcommandParser: subcommandParser)
            return (wrench.subcommand, wrench)
        }
        wrenches = Dictionary(uniqueKeysWithValues: subcommandMap)

    }

    public func run() throws {
        let arguments = try wrenchParser.parse(Array(CommandLine.arguments.dropFirst()))
        guard let subcommand = arguments.subparser(wrenchParser),
            let wrench = wrenches[subcommand] else {
                throw WrenchError.noSubcommandPassed
        }
        try wrench.read(arguments: arguments)

        // Source the files to process.
        var sourceFiles = Set<SelectedFile>()
        try wrench.commandArguments.values.forEach { argument in
            if let fileSourceFactory = argument as? FileSourceFactory, let fileSources = fileSourceFactory.fileSources {
                sourceFiles = sourceFiles.union(try fileSources.flatMap { try $0.getFiles() })
            }
        }

        try wrench.execute(onFiles: sourceFiles.filter(wrench.fileFilter))
    }
}
