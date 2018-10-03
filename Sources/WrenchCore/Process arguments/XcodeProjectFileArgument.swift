
//  Created by Derek Clarkson on 18/9/18.

import Files
import Utility

class XCodeProjectFilesArgument: CommandArgument, FileSourceFactory {

    static let argumentSyntax: String? = "<project.xcodeproj>, ..."

    let projectDirs: PositionalArgument<[String]>

    var fileSources: [FileSource]? = nil

    required init(argumentParser: ArgumentParser) {

        projectDirs = argumentParser.add(positional: "<project.xcodeproj>, ...",
                                         kind: [String].self,
                                         optional: true,
                                         strategy: .remaining,
                                         usage: "Zero or more project files to proecess. If you're using the Git arguments to find changed project files " +
            "then there is no need to specify projects here, otherwise list the project files you want to process.")
    }

    func read(arguments: ArgumentParser.Result) throws {
        if let dirs = arguments.get(projectDirs) {
            fileSources = try dirs.map { try fileSource(forFolder: $0) }
        }
    }

    private func fileSource(forFolder folderPath: String) throws -> FileSource {

        guard let folder = try? Folder(path: folderPath) else {
            throw WrenchError.folderNotFound(folderPath)
        }

        guard folder.extension == "xcodeproj" else {
            throw WrenchError.incorrectFile("'\(folder.name)' should be an xcode project file (directory), for example MyProject.xcodeproj")
        }

        return DirectoryFileSource(directory: folder)
    }
}
