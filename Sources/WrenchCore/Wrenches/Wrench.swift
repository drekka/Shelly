
//  Created by Derek Clarkson on 13/9/18.

import Files
import Foundation

public protocol Wrench {
    var fileFilter: (SelectedFile) -> Bool { get }
    func execute(_ files: Set<SelectedFile>) throws -> Bool
}
