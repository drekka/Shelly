
//  Created by Derek Clarkson on 18/9/18.

import Utility
import xcodeproj

class SortXcodeArgument: CommandArgument {

    static let argumentSyntax = "[--sort-navigator-by-name|--sort-navigator-by-name-folders-first] [--sort-files]"

    private let sortXcodeNavigatorByName: OptionArgument<Bool>
    private let sortXcodeNavigatorByNameFoldersFirst: OptionArgument<Bool>
    private let sortXcodeFiles: OptionArgument<Bool>

    private(set) var navigatorSortOrder = PBXNavigatorFileOrder.unsorted
    private(set) var sortFiles = false

    required init(argumentParser: ArgumentParser) {
        sortXcodeNavigatorByName = argumentParser.add(option: "--sort-navigator-by-name",
                                                kind: Bool.self,
                                                usage: "Sorts files listed in the xcode project file by their name.")
        sortXcodeNavigatorByNameFoldersFirst = argumentParser.add(option: "--sort-navigator-by-name-folders-first",
                                                kind: Bool.self,
                                                usage: "Sorts files listed in the xcode project file by their name with all folders first.")
        sortXcodeFiles = argumentParser.add(option: "--sort-files",
                                            kind: Bool.self,
                                            usage: "Sorts file lists with the Xcode project file and build phases.")
    }

    func read(arguments: ArgumentParser.Result) throws {

        self.sortFiles = arguments.get(sortXcodeFiles) ?? false

        if arguments.get(sortXcodeNavigatorByName) ?? false {
                navigatorSortOrder = .byFilename
        } else if arguments.get(sortXcodeNavigatorByNameFoldersFirst) ?? false {
                navigatorSortOrder = .byFilenameGroupsFirst
        }
    }
}
