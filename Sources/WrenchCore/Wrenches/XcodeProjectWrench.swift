
//  Created by Derek Clarkson on 18/9/18.

import Foundation
import Files

class XcodeProjectWrench: Wrench {
    
    func canProcess(file: SelectedFile) -> Bool {
        return file.file.extension == "pbproj"
    }
    
    func execute(_ files: Set<SelectedFile>) {
        print("tightening with the xcode project wrench...")
    }
}
