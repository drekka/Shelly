
//  Created by Derek Clarkson on 18/9/18.

import Foundation
import Files
import xcodeproj
import Basic

class XcodeProjectWrench: Wrench {
    
    private var navigatorSortOrder: ProjectNavigatorSortOrder
    private var sortFiles: Bool
    
    init(navigatorSortOrder: ProjectNavigatorSortOrder, sortFiles: Bool = false) {
        self.sortFiles = sortFiles
        self.navigatorSortOrder = navigatorSortOrder
    }
    
    func canProcess(file: SelectedFile) -> Bool {
        return file.file.extension == "pbxproj"
    }
    
    func execute(_ files: Set<SelectedFile>) throws {
        print("tightening with the xcode project wrench...")
        
        try files.filter(canProcess).forEach { projectFile in
            
            if let projDir = projectFile.file.parent?.path {
                let projPath = AbsolutePath(projDir)
                let proj = try XcodeProj(path: projPath)
                proj.pbxproj.navigatorGroupSortOrder = navigatorSortOrder
                proj.pbxproj.fileListSortOrder = sortFiles ? .byFilename : .byUUID
                proj.pbxproj.buildPhaseFileSortOrder = sortFiles ? .byFilename : .unsorted
                try proj.write(path: projPath, override: true)
            }
        }
        
    }
    
    
}
