
//  Created by Derek Clarkson on 18/9/18.

import Basic
import Files
import Foundation
import xcodeproj

class XcodeProjectSortWrench: Wrench {
    private var navigatorSortOrder: PBXNavigatorFileOrder
    private var sortFiles: Bool

    var fileFilter: (SelectedFile) -> Bool = { file in
        return file.file.extension == "pbxproj"
    }

    init(navigatorSortOrder: PBXNavigatorFileOrder, sortFiles: Bool = false) {
        self.sortFiles = sortFiles
        self.navigatorSortOrder = navigatorSortOrder
    }

    func execute(_ files: Set<SelectedFile>) throws -> Bool {
        wrenchLog("tightening with the xcode project wrench...")

        try files.forEach { projectFile in

            if let projDir = projectFile.file.parent?.path {
                let projPath = AbsolutePath(projDir)
                let proj = try XcodeProj(path: projPath)
                let outputSettings = PBXOutputSettings(projFileListOrder: sortFiles ? .byFilename : .byUUID,
                                                       projNavigatorFileOrder: navigatorSortOrder,
                                                       projBuildPhaseFileOrder: sortFiles ? .byFilename : .unsorted)
                try proj.write(path: projPath, override: true, outputSettings: outputSettings)
            }
        }

        return true
    }
}
