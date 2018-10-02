
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

    var commandArguments: [String: CommandArgument] = [:]

    var fileFilter: (SelectedFile) -> Bool = { $0.file.extension == "pbxproj" }

    required init() {}

    func execute(onFiles files: Set<SelectedFile>) throws {
        wrenchLog("tightening with the xcode project wrench...")

//        try files.forEach { projectFile in
//
//            if let projDir = projectFile.file.parent?.path {
//                let projPath = AbsolutePath(projDir)
//                let proj = try XcodeProj(path: projPath)
//                let outputSettings = PBXOutputSettings(projFileListOrder: sortArguments.sortFiles ? .byFilename : .byUUID,
//                                                       projNavigatorFileOrder: sortArguments.navigatorSortOrder,
//                                                       projBuildPhaseFileOrder: sortArguments.sortFiles ? .byFilename : .unsorted)
//                try proj.write(path: projPath, override: true, outputSettings: outputSettings)
//            }
//        }

    }
}
