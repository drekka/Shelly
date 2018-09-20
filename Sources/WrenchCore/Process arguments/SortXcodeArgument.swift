
//  Created by Derek Clarkson on 18/9/18.

import Utility
import Files
import xcodeproj

struct SortXcodeArgument: CommandArgument {
    
    static let argumentSyntax: String? = "<--sort-xcode-navigator by-name|by-name-folders-first> <--sort-xcode-files>"
    
    private let sortXcodeNavigator: OptionArgument<String>
    private let sortXcodeFiles: OptionArgument<Bool>

    init(argumentParser: ArgumentParser) {
        sortXcodeNavigator = argumentParser.add(option: "--sort-xcode-navigator",
                                       kind: String.self,
                                       usage: "\"by-name\" sorts files listed in the xcode project file by their name." +
        "\"by-name-folders-first\" sorts the folders first then the files in aphabatical order.")
        sortXcodeFiles = argumentParser.add(option: "--sort-xcode-files",
                                                kind: Bool.self,
                                                usage: "Sorts file lists with the Xcode project file to minimise merge issues.")
    }
    
    func activate(arguments: ArgumentParser.Result, toolbox: Toolbox) throws {
        
        let sortNavigatorBy = arguments.get(sortXcodeNavigator)
        let sortFiles = arguments.get(sortXcodeFiles) ?? false
        
        if sortNavigatorBy != nil || sortFiles {
            
            var navigatorSortOrder = ProjectNavigatorSortOrder.unsorted
            
            if let sortNavigatorBy = sortNavigatorBy {
                switch sortNavigatorBy {
                    
                case "by-name":
                    navigatorSortOrder = .byFilename
                    
                case "by-name-folders-first":
                    navigatorSortOrder = .byFilenameGroupsFirst
                    
                default:
                    throw WrenchError.unknownArgument(sortNavigatorBy)
                }
            }
            
            toolbox.addWrench(XcodeProjectWrench(navigatorSortOrder: navigatorSortOrder, sortFiles: sortFiles))
        }
    }
}

