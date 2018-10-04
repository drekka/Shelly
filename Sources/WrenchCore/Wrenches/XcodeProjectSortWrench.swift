
//  Created by Derek Clarkson on 18/9/18.

import Basic
import Files
import Utility
import xcodeproj

class XcodeProjectSortWrench: Wrench {

    let subcommand = "sortprojects"
    let overview = "Sorts the Xcode project file to aleviate merge issues."
    let argumentClasses: [CommandArgument.Type] = [
        GitStagingArgument.self,
        GitChangesArgument.self,
        SortXcodeArgument.self,
        XCodeProjectFilesArgument.self,
        ]

    var argumentHandlers: [String: CommandArgument] = [:]

    var fileFilter: (SelectedFile) -> Bool = { $0.file.extension == "pbxproj" }

    required init() {}

    func execute(onFiles files: Set<SelectedFile>) throws {

        let sortArguments: SortXcodeArgument = try argumentHandler()
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

        try files.forEach { projectFile in
            wrenchLog("Sorting \(projectFile.file.path)")

            if let projDir = projectFile.file.parent?.path {
                let projPath = AbsolutePath(projDir)
                let proj = try XcodeProj(path: projPath)
                let outputSettings = PBXOutputSettings(projFileListOrder: sortArguments.sortFiles ? .byFilename : .byUUID,
                                                       projNavigatorFileOrder: sortArguments.navigatorSortOrder,
                                                       projBuildPhaseFileOrder: sortArguments.sortFiles ? .byFilename : .unsorted)
                try proj.write(path: projPath, outputSettings: outputSettings)
            }
        }
    }
}
