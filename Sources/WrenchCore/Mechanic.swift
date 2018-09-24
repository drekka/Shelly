
//  Created by Derek Clarkson on 12/9/18.

import Files
import Foundation
import SwiftShell
import Utility

func wrenchLog(_ message: String) {
    main.stdout.print(message)
}

func wrenchLogError(_ message: String) {
    main.stderror.print("Error !!!!!!!!!")
    main.stderror.print(message)
    main.stderror.print("")
}

protocol Toolbox {
    var fileSourcesEmpty: Bool { get }
    func add(fileSource: FileSource)
    func add(wrench: Wrench)
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

    func add(fileSource: FileSource) {
        fileSources.append(fileSource)
    }

    func add(wrench: Wrench) {
        wrenches.append(wrench)
    }

    // MARK: - Process

    public func run() {
        do {
            let parsedArguments = try argumentParser.parse(Array(CommandLine.arguments.dropFirst()))
            try arguments.forEach { try $0.activate(arguments: parsedArguments, toolbox: self) }
            try processFiles()
        } catch let error {
            wrenchLogError(String(describing: error))
            exit(1)
        }
    }

    // MARK: - Execution

    private func processFiles() throws {
        
        if wrenches.isEmpty {
            wrenchLogError("No active wrenches. Did you forget to add some arguments?")
            exit(1)
        }

        // This will also dep.
        let wrenchFileLists = self.wrenches.map { (HashableWrench(wrench: $0), Set<SelectedFile>()) }
        var wrenchFiles = Dictionary<HashableWrench, Set<SelectedFile>>(uniqueKeysWithValues: wrenchFileLists)

        wrenchLog("Reading file sources ...")
        try fileSources.forEach { fileSource in
            let files = try fileSource.getFiles()
            wrenchFiles.forEach { key, value in
                wrenchFiles[key] = value.union(files.filter(key.fileFilter))
            }
        }

        var success = true
        try wrenchFiles.forEach { key, value in
            if try !key.execute(value) {
                success = false
            }
        }

        if !success {
            exit(1)
        }
    }
}

/// Used purely so we can use wrenchs as dictionary keys without having to force implementations of Hashable.
class HashableWrench: Wrench, Hashable {

    private var wrench: Wrench
    private let uuid = UUID()

    var fileFilter: (SelectedFile) -> Bool {
        return wrench.fileFilter
    }

    public var hashValue: Int {
        return uuid.hashValue
    }

    func execute(_ files: Set<SelectedFile>) throws -> Bool {
        return try wrench.execute(files)
    }

    init(wrench: Wrench) {
        self.wrench = wrench
    }

    public static func ==(lhs: HashableWrench, rhs: HashableWrench) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
