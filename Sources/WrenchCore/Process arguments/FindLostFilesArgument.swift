
//  Created by Derek Clarkson on 18/9/18.

import Files
import Utility

struct FindLostFilesArgument: CommandArgument {
    static let argumentSyntax: String? = "[--find-lost-files|--find-lost-files-excluding <mask>]"

    private let findLostFiles: OptionArgument<Bool>
    private let findLostFilesExcluding: OptionArgument<String>

    init(argumentParser: ArgumentParser) {
        findLostFiles = argumentParser.add(option: "--find-lost-files",
                                           kind: Bool.self,
                                           usage: "Cross references the source files listed in the project with " +
                                               "those in the file system to locate any lost files resulting from a bad merge.")
        findLostFilesExcluding = argumentParser.add(option: "--find-lost-files-excluding",
                                                    kind: String.self,
                                                    usage: "Same as --find-lost-files but also excludes any files that match the supplied mask. " +
                                                        "The mask utilises asterisks to act as wildcards. So *.swift, Sources/*/*.swift, Sources/ABC*, etc all work.")
    }

    func activate(arguments: ArgumentParser.Result, toolbox: Toolbox) throws {
        if let excludes = arguments.get(findLostFilesExcluding) {
            print("Looking for lost files excluding \(excludes) ...")
            toolbox.addWrench(try XcodeProjectFileCheckWrench(excluding: excludes))
        } else if arguments.get(findLostFiles) ?? false {
            print("Looking for lost files ...")
            toolbox.addWrench(try XcodeProjectFileCheckWrench(excluding: nil))
        }
    }
}
