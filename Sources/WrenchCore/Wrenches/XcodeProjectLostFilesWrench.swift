
//  Created by Derek Clarkson on 18/9/18.

import Basic
import Utility
import SwiftShell
import xcodeproj
import Foundation

private extension Set where Element == RelativePath {

    mutating func subtract(filesMatchingExpressions expressions: [NSRegularExpression]) {
        let filesToRemove = self.filter { file in
            return expressions.first { expression in
                let filename = file.asString
                return expression.rangeOfFirstMatch(in: filename, options: [], range: NSRange(location: 0, length: filename.count)).location != NSNotFound
                } != nil
        }
        self.subtract(filesToRemove)
    }
}


class XcodeProjectLostFilesWrench: Wrench {

    let subcommand = "lostfiles"
    let overview = "Finds 'lost' files resulting from a merge or other event."
    let argumentClasses: [CommandArgument.Type] = [
        XcodeProjectFileArgument.self,
        ExcludeArgument.self,
        SourceDirectoriesArgument.self,
        ]

    var arguments: [String: CommandArgument] = [:]

    required init() {}

    func execute() throws {

        wrenchLog("Looking for lost files ...")

        // Get a list of all swift source files from the directories and run the exclude masks.
        let sourceDirectoriesArgument: SourceDirectoriesArgument = try retrieveArgument()
        var sourceFiles: Set<RelativePath> = Set()
        try sourceDirectoriesArgument.fileSources?.forEach { sourceFiles = sourceFiles.union(try $0.getFiles()) }

        // Special filters.
        // Remove directories and hidden files.
        sourceFiles = sourceFiles.filter { !localFileSystem.isDirectory($0.absolutePath) }
        sourceFiles = sourceFiles.filter { !$0.basename.hasPrefix(".") }

        let excludeArgument: ExcludeArgument = try retrieveArgument()
        if let masks = excludeArgument.excludeMasks {
            wrenchVerboseLog("Excluding files matching \(masks.joined(separator: " ")) ...")
            let excludeExpressions = try excludeRegularExpressions(fromMasks: masks)
            sourceFiles.subtract(filesMatchingExpressions: excludeExpressions)
        }

        // Load up the project
        let projectArgument: XcodeProjectFileArgument = try retrieveArgument()
        guard let project = projectArgument.project else {
            throw WrenchError.missingArgument(XcodeProjectFileArgument.argumentSyntax)
        }
        let projectFiles = Set(try project.pbxproj.buildFiles.compactMap { try $0.file?.fullPath(sourceRoot: projectRoot)?.relative(to: projectRoot) })

        wrenchVerboseLog("Comparing \(sourceFiles.count) source files against \(projectFiles.count) project files")

        // And report.
        let missingFiles = projectFiles.filter { !localFileSystem.exists($0.absolutePath) }
        if !missingFiles.isEmpty {
            wrenchLog("\nMissing files (files in project but not found in the file system):")
            missingFiles.forEach { wrenchLog("\t\($0.asString)") }
            wrenchLog("")
        }

        // Check for files on disk that are not in the project.
        let lostFiles = sourceFiles.subtracting(projectFiles)
        if !lostFiles.isEmpty {
            wrenchLog("\nLost files (files in file system that are not in the project):")
            lostFiles.forEach { wrenchLog("\t\($0.asString)") }
            wrenchLog("")
        }
    }

    private func excludeRegularExpressions(fromMasks masks: [String]) throws -> [NSRegularExpression] {
        return try masks.flatMap { $0.components(separatedBy: ",") }
            .map { mask in
                let filterPattern = "^" + mask.replacingOccurrences(of: "*", with: ".*") + "$"
                return try NSRegularExpression(pattern: filterPattern)
        }
    }
}
