
//  Created by Derek Clarkson on 12/9/18.

import Files
import Foundation
import SwiftShell
import Utility

protocol Toolbox {
    var fileSourcesEmpty: Bool { get }
    func addFileSource(_ fileSource: FileSource)
    func addWrench(_ wrench: Wrench)
}

public class Mechanic: Toolbox {
    private let argumentParser: ArgumentParser

    private var fileSources: [FileSource] = []
    private var wrenches: [Wrench] = []

    private let arguments: [CommandArgument]

    public init() {
        let argumentClasses: [CommandArgument.Type] = [
            GitStagingArgument.self,
            GitChangesArgument.self,
            RootDirectoryArgument.self,
            FindLostFilesArgument.self,
            SortXcodeArgument.self,
            DirectoryArgument.self, // Must be second to last.
            PipedFilesArgument.self, // Must be last.
        ]
        let usage = argumentClasses.compactMap { $0.argumentSyntax }.joined(separator: " ")

        let parser = ArgumentParser(commandName: "wrench [--help]",
                                    usage: usage,
                                    overview: "A useful set of tools for managing an Xcode project. " +
                                        "Wrench can perform a variety of project related functions. " +
                                        "It can source files to process from a variety of sources, " +
                                        "or piped from another command.")

        arguments = argumentClasses.map { $0.init(argumentParser: parser) }
        argumentParser = parser
    }

    // MARK: - Toolbox protocol

    var fileSourcesEmpty: Bool {
        return fileSources.isEmpty
    }

    func addFileSource(_ fileSource: FileSource) {
        fileSources.append(fileSource)
    }

    func addWrench(_ wrench: Wrench) {
        wrenches.append(wrench)
    }

    // MARK: - Process

    public func run() {
        do {
            let parsedArguments = try argumentParser.parse(Array(CommandLine.arguments.dropFirst()))
            try arguments.forEach { try $0.activate(arguments: parsedArguments, toolbox: self) }
            try processFiles()
        } catch let error {
            print("Error !!!!!!!!!")
            print(error)
            exit(1)
        }
    }

    // MARK: - Execution

    private func processFiles() throws {
        if wrenches.isEmpty {
            print("Error: No active wrenches. Did you forget to add some arguments?")
            exit(1)
        }

        // Build the file filter from the list of wrenches.
        let processableFileFilter: ((SelectedFile) -> Bool)? = wrenches.reduce(nil) { (result, wrench) -> (SelectedFile) -> Bool in
            if let result = result {
                return { file in
                    result(file) || wrench.canProcess(file: file)
                }
            }
            return wrench.canProcess
        }

        guard let fileFilter = processableFileFilter else {
            print("No files found for currently active wrenches. Perhaps you're not doing enough coding.")
            exit(0)
        }

        print("Reading file sources")
        var files = Set<SelectedFile>()
        try fileSources.forEach { fileSource in
            files = files.union(try fileSource.getFiles().filter(fileFilter))
        }

        var success = true
        try wrenches.forEach { wrench in
            if try !wrench.execute(files) {
                success = false
            }
        }

        print("")

        if !success {
            exit(1)
        }
    }
}
