
//  Created by Derek Clarkson on 18/9/18.

import Utility
import Basic
import xcodeproj

class XcodeProjectFileArgument: CommandArgument {

    static let argumentSyntax = "<project.xcodeproj>"

    private let projectArg: PositionalArgument<RelativePathArgument>
    var project: XcodeProj?

    required init(argumentParser: ArgumentParser) {
        projectArg = argumentParser.add(positional: "<project.xcodeproj>",
                                        kind: RelativePathArgument.self,
                                        usage: "Project file (package).")
    }

    func parse(arguments: ArgumentParser.Result) throws {
        if let projectPath = arguments.get(projectArg)?.path {
            project = try projectPath.loadProject()
        }
    }
}

class TrailingXcodeProjectPackagesArgument: CommandArgument {

    static let argumentSyntax = "<project.xcodeproj> ..."

    let projectDirs: PositionalArgument<[RelativePathArgument]>
    var projects: [XcodeProj] = []

    required init(argumentParser: ArgumentParser) {

        projectDirs = argumentParser.add(positional: "<project.xcodeproj>, ...",
                                         kind: [RelativePathArgument].self,
                                         optional: true,
                                         strategy: .remaining,
                                         usage: "Zero or more project files (packages) to process. If you're using the Git arguments to find changed project files " +
            "then there is no need to specify projects here, otherwise list the project files you want to process.")
    }

    func parse(arguments: ArgumentParser.Result) throws {
        projects = try (arguments.get(projectDirs) ?? []).map { try $0.path.loadProject() }
    }
}
