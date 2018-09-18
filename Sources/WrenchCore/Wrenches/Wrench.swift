
//  Created by Derek Clarkson on 13/9/18.

import Foundation
import Files

public protocol Wrench {
    func canProcess(file: SelectedFile) -> Bool
    func execute(_ files: Set<SelectedFile>)
}
