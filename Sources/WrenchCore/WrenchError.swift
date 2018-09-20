
//  Created by Derek Clarkson on 18/9/18.

import Foundation

enum WrenchError: Error, CustomStringConvertible {
    
    case folderNotFound(String)
    
    case unknownArgument(String)
    
    var description: String {
        
        switch self {

        case .folderNotFound(let filePath):
            return "Folder not found: \(filePath)"
            
        case .unknownArgument(let arg):
            return "Unknown argument: \(arg)"
        }
    }
}
