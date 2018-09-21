
//  Created by Derek Clarkson on 18/9/18.

import Basic
import Files
import Foundation
import SwiftShell
import xcodeproj

class XcodeProjectFileCheckWrench: Wrench {
    private var excludes: RegEx?

    init(excluding: String? = nil) throws {
        if let excluding = excluding {
            let regexPattern = "^" + excluding.replacingOccurrences(of: "*", with: ".*") + "$"
            excludes = try RegEx(pattern: regexPattern)
        }
    }

    func canProcess(file: SelectedFile) -> Bool {
        return file.file.extension == "pbxproj"
    }

    func execute(_ files: Set<SelectedFile>) throws -> Bool {
        print("Hunting for lost source files ...")

        var result = true

        try files.filter(canProcess).forEach { projectFile in

            if let projectFileDir = projectFile.file.parent?.path {
                // Source the file lists.
                var filesInGit = try gitFiles()
                var buildFiles = try projectFiles(fromProjectIn: projectFileDir)

                if let excludes = excludes {
                    filesInGit = filesInGit.filter { !excludes.matchGroups(in: $0).isEmpty }
                    buildFiles = buildFiles.filter { !excludes.matchGroups(in: $0).isEmpty }
                }

                let missingFiles = buildFiles.compactMap { file in
                    FileManager.default.fileExists(atPath: file) ? nil : file
                }
                if !missingFiles.isEmpty {
                    print("\nMissing files (files in project but not on file system):")
                    missingFiles.forEach { print("\t\($0)") }
                    print("")
                    result = false
                }

                let lostFiles = filesInGit.subtracting(buildFiles)
                if !lostFiles.isEmpty {
                    print("\nLost files (files in file system that are not in the project):")
                    lostFiles.forEach { print("\t\($0)") }
                    print("")
                    result = false
                }
            }
        }

        return result
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
