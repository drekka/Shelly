
//  Created by Derek Clarkson on 18/9/18.

import Foundation
import Files

/// Wrapper for files selected for processing.
open class SelectedFile: CustomStringConvertible, Equatable, Hashable {

    public static func == (lhs: SelectedFile, rhs: SelectedFile) -> Bool {
        return lhs.file == rhs.file
    }
    
    open var hashValue: Int {
        return file.path.hashValue
    }
    
    let file: File
    var obj: Any?
    
    init(file: String) throws {
        self.file = try File(path: file)
    }
    
    init(file: File) {
        self.file = file
    }
    
    open var description: String {
        return file.path
    }
}
