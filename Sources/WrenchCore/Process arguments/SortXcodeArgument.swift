
//  Created by Derek Clarkson on 18/9/18.

import Files
import Utility
import xcodeproj

class SortXcodeArgument: CommandArgument {

    static let argumentSyntax: String? = "[--sort-xcode-navigator by-name|by-name-folders-first] [--sort-xcode-files]"

    private let sortXcodeNavigator: OptionArgument<String>
    private let sortXcodeFiles: OptionArgument<Bool>

    private(set) public var navigatorSortOrder = PBXNavigatorFileOrder.unsorted
    private(set) public var sortFiles = false

    required init(argumentParser: ArgumentParser) {
        sortXcodeNavigator = argumentParser.add(option: "--sort-xcode-navigator",
                                                kind: String.self,
                                                usage: "\"by-name\" sorts files listed in the xcode project file by their name." +
            "\"by-name-folders-first\" sorts the folders first then the files in aphabatical order.")
        sortXcodeFiles = argumentParser.add(option: "--sort-xcode-files",
                                            kind: Bool.self,
                                            usage: "Sorts file lists with the Xcode project file to minimise merge issues.")
    }

    func read(arguments: ArgumentParser.Result) throws {

        self.sortFiles = arguments.get(sortXcodeFiles) ?? false

        if let sortNavigatorBy = arguments.get(sortXcodeNavigator) {
            switch sortNavigatorBy {
            case "by-name":
                navigatorSortOrder = .byFilename

            case "by-name-folders-first":
                navigatorSortOrder = .byFilenameGroupsFirst

            default:
                throw WrenchError.unknownArgument(sortNavigatorBy)
            }
        }
    }
}
