
//  Created by Derek Clarkson on 18/9/18.

import Basic
import Utility
import xcodeproj

class XcodeProjectSortWrench: Wrench, FileProcessor {

    let subcommand = "sortprojects"
    let overview = "Sorts the Xcode project file to aleviate merge issues."
    let argumentClasses: [CommandArgument.Type] = [
        GitStagingArgument.self,
        GitChangesArgument.self,
        SortXcodeArgument.self,
        TrailingXcodeProjectPackagesArgument.self,
        ]

    var arguments: [String: CommandArgument] = [:]

    var fileFilter: ((RelativePath) -> Bool)? = { $0.extension == "pbxproj" }

    required init() {}

    func execute() throws {

        let sortArguments: SortXcodeArgument = try getArgument()

        wrenchLog("🔧 Sorting file lists within project files...")
        wrenchLog("\t► Project file lists: " + (sortArguments.sortFiles ? "In file name order" : "In uuid order"))
        switch sortArguments.navigatorSortOrder {
        case .byFilename:
            wrenchLog("\t► Navigator groups: In file name order")
        case .byFilenameGroupsFirst:
            wrenchLog("\t► Navigator groups: In file name order with groups first")
        default:
            wrenchLog("\t► Navigator groups: Unsorted")
        }
        wrenchLog("\t► Build phase file lists: " + (sortArguments.sortFiles ? "In file name order" : "Unsorted"))

        try files().forEach { projectFile in

            wrenchLog("🔧 Sorting \(projectFile.asString)")

            let proj = try projectFile.loadProject()
            let outputSettings = PBXOutputSettings(projFileListOrder: sortArguments.sortFiles ? .byFilename : .byUUID,
                                                   projNavigatorFileOrder: sortArguments.navigatorSortOrder,
                                                   projBuildPhaseFileOrder: sortArguments.sortFiles ? .byFilename : .unsorted)
            try proj.write(path: projectFile.absolutePath, outputSettings: outputSettings)
        }
    }
}
