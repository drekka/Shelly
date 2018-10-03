
//  Created by Derek Clarkson on 18/9/18.

import Files
import Utility

class FindLostFilesArgument: CommandArgument {

    static let argumentSyntax: String? = "[--find-lost-files dir dir ... [--find-lost-files-excluding mask mask ...]]"

    private let sourceDirectories: OptionArgument<[String]>
    private let findLostFilesExcluding: OptionArgument<[String]>

    required init(argumentParser: ArgumentParser) {
        let subParser = argumentParser.add(subparser: "lostfiles", overview: "Searches for files 'lost' as a result of a merge or other event.")
        sourceDirectories = subParser.add(option: "--find-lost-files",
                                           kind: [String].self,
                                           usage: "Cross references the source files listed in the specified directories with " +
                                               "those in the project to locate any lost files resulting from a bad merge.")
        findLostFilesExcluding = subParser.add(option: "--find-lost-files-excluding",
                                                    kind: [String].self,
                                                    usage: "Same as --find-lost-files but also excludes any files that match the supplied mask. " +
                                                        "The mask utilises asterisks to act as wildcards. So *.swift, Sources/*/*.swift, Sources/ABC*, etc all work.")
    }

    func read(arguments: ArgumentParser.Result) throws {
        let sourceDirs = arguments.get(sourceDirectories)
        if let sourceDirs = sourceDirs {
            let excludeMasks = arguments.get(findLostFilesExcluding)
//            toolbox.add(wrench: try XcodeProjectFileCheckWrench(sourceDirectories: sourceDirs, excludeMasks: excludeMasks))
        }
    }
}
