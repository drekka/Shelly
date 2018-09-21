
//  Created by Derek Clarkson on 17/9/18.

import Files
import Foundation

// Need File to be hashable for set processing to remove duplicates.
extension File: Hashable {
    public var hashValue: Int {
        return path.hashValue
    }
}
