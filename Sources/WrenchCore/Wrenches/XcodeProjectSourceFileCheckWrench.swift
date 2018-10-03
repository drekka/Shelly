
//  Created by Derek Clarkson on 18/9/18.

import Basic
import Files
import Utility
import SwiftShell
import xcodeproj
import Foundation

class XcodeProjectFileCheckWrench: Wrench {

    let subcommand = "lostfiles"
    let overview = "Finds 'lost' files resulting from a merge or other event."
    let argumentClasses: [CommandArgument.Type] = [
        FindLostFilesArgument.self,
    ]

    var argumentHandlers: [String: CommandArgument] = [:]

    required init() {}

    private var sourceDirectories: [String]!
    private var excludes: [RegEx]?
    private var excludePattern = ""

    var fileFilter: (SelectedFile) -> Bool = { $0.file.extension == "pbxproj" }

//    init(sourceDirectories: [String], excludeMasks: [String]?) throws {
//        self.sourceDirectories = sourceDirectories
//        if let excludeMasks = excludeMasks {
//            excludePattern = excludeMasks.joined(separator: ",")
//
//            // break up the passed command delimited cxcludes and build a regex for each.
//            let filters = excludeMasks.map { "^" + $0.replacingOccurrences(of: "*", with: ".*") + "$" }
//            excludes = try filters.map { try RegEx(pattern: $0) }
//        }
//    }

    func execute(onFiles files: Set<SelectedFile>) throws {

//        try files.forEach { projectFile in
//
//            if excludes != nil {
//                wrenchLog("Looking for lost files excluding \(excludePattern) ...")
//            } else {
//                wrenchLog("Looking for lost files ...")
//            }
//
//            if let projectFileDir = projectFile.file.parent?.path {
//                // Source the file lists.
//                var filesInGit = try gitFiles()
//                let buildFiles = try projectFiles(fromProjectIn: projectFileDir)
//
//                // Loop through the exclude patterns and remove any matching files from the list of files to check.
//                if let excludes = excludes {
//                    excludes.forEach { filter in
//                        filesInGit = filesInGit.filter { !filter.matchGroups(in: $0).isEmpty }
//                    }
//                }
//
//                // Check the list of files from the project to ensure they're on disk.
//                let missingFiles = buildFiles.compactMap { file in
//                    FileManager.default.fileExists(atPath: file) ? nil : file
//                }
//
//                // And report.
//                if !missingFiles.isEmpty {
//                    wrenchLog("\nMissing files (files in project but not on file system):")
//                    missingFiles.forEach { wrenchLog("\t\($0)") }
//                    wrenchLog("")
//                    result = false
//                }
//
//                // Check for files on disk that are not in the project.
//                let lostFiles = filesInGit.subtracting(buildFiles)
//                if !lostFiles.isEmpty {
//                    wrenchLog("\nLost files (files in file system that are not in the project):")
//                    lostFiles.forEach { wrenchLog("\t\($0)") }
//                    wrenchLog("")
//                    result = false
//                }
//            }
//        }
    }

    private func gitFiles() throws -> Set<String> {
        let result = run(bash: "git ls-files --cached --modified --other --exclude-from=.gitignore | grep .*\\.swift")
        if let error = result.error {
            throw error
        }
        return Set<String>(result.stdout.lines())
    }

    private func projectFiles(fromProjectIn projectFileDir: String) throws -> Set<String> {
        let projectDir = AbsolutePath(Files.currentDirectoryPath)
        let project = try XcodeProj(path: AbsolutePath(projectFileDir))

        let projectBuildSwiftFiles = project.pbxproj.buildFiles.filter { return $0.file?.path?.hasSuffix(".swift") ?? false }
        let projectBuildFiles = try projectBuildSwiftFiles.compactMap { file throws -> String? in
            guard let filePath = try file.file?.fullPath(sourceRoot: projectDir) else {
                return nil
            }
            return filePath.relative(to: projectDir).asString
        }
        return Set<String>(projectBuildFiles)
    }
}
