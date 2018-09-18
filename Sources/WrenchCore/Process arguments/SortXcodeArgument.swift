
//  Created by Derek Clarkson on 18/9/18.

import Utility
import Files

struct SortXcodeArgument: CommandArgument {
    
    private let sortXcode: OptionArgument<Bool>
    
    init(argumentParser: ArgumentParser) {
        sortXcode = argumentParser.add(option: "--sort-xcode",
                                       kind: Bool.self,
                                       usage: "Sorts files listed in the xcode project file. " +
            "This addresses the files and groups in the project navigator and any files listed in build phases.")
    }
    
    func activate(arguments: ArgumentParser.Result, toolbox: Toolbox) throws {
        if arguments.get(sortXcode) ?? false {
            toolbox.addWrench(XcodeProjectWrench())
        }
    }
}

