
//  Created by Derek Clarkson on 12/9/18.

import Utility
import Foundation
import SwiftShell
import Files

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
        
        argumentParser = ArgumentParser(commandName: "wrench",
                                        usage: "<options> <project-dir>, ...",
                                        overview: "A useful set of tools for managing an Xcode project.")
        arguments = [
            SortXcodeArgument(argumentParser: argumentParser),
            RootDirectoryArgument(argumentParser: argumentParser),
            GitStagingArgument(argumentParser: argumentParser),
            GitChangesArgument(argumentParser: argumentParser),
            DirectoryArgument(argumentParser: argumentParser), // Must be second to last.
            PipedFilesArgument(argumentParser: argumentParser), // Must be last.
        ]
    }
    
    // MARK:- Toolbox protocol
    
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
        }
        catch let error as ArgumentParserError {
            print("Error \(error.description)")
        }
        catch let error {
            print("Error \(error.localizedDescription)")
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
                    return result(file) || wrench.canProcess(file: file)
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
        
        wrenches.forEach { wrench in
            wrench.execute(files)
        }
    }
}
