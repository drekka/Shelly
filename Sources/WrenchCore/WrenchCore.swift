
//  Created by Derek Clarkson on 12/9/18.

import Utility
import Foundation
import SwiftShell

protocol FileSource {
    var files: [Foundation.URL] { get }
}

class GitStagingFileSource {
    var files: [Foundation.URL] {
        return []
    }
}

protocol Wrench {
    func canProcess(file: Foundation.URL) -> Bool
}

class GitStagingWrench: Wrench {
    
    func canProcess(file: Foundation.URL) -> Bool {
    return false
    }
}

public class Toolbox {
    
    let argumentParser: ArgumentParser
    let scanGitStaging: OptionArgument<Bool>
    let scanGitChanges: OptionArgument<Bool>
    let projectDirs: PositionalArgument<[String]>
    
    public init() {
        
        argumentParser = ArgumentParser(commandName: "wrench",
                                        usage: "<options> project-dir, ...",
                                        overview: "A useful set of tools for managing Xcode's project file.")
        
        scanGitStaging = argumentParser.add(option: "--scan-git-staging",
                                            kind: Bool.self,
                                            usage: "Scans the Git staging area for project files.")
        
        scanGitChanges = argumentParser.add(option: "--scan-git-changes",
                                            kind: Bool.self,
                                            usage: "Scans Git changed but not staged files for project files.")
        
        projectDirs = argumentParser.add(positional: "project-dir, ...",
                                         kind: [String].self,
                                         optional: true,
                                         strategy: .remaining,
                                         usage: "One or more project directories to look for Xcode project files in.")
        
    }
    
    public func run() {
        do {
            
            let parsedArguments = try argumentParser.parse(Array(CommandLine.arguments.dropFirst()))
            
            if let dirs = parsedArguments.get(projectDirs) {
                print("Dirs \(dirs)")
            } else {
                let pipedFiles = main.stdin
                pipedFiles.lines().forEach { line in
                    print("< \(line)")
                }
            }
            
            if parsedArguments.get(scanGitStaging) ?? false {
                print("Scanning Git staging area")
            }
            
            if parsedArguments.get(scanGitChanges) ?? false {
                print("Scanning Git changes")
            }
        }
        catch let error as ArgumentParserError {
            print(error.description)
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
}
