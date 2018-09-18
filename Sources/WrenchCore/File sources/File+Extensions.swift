
//  Created by Derek Clarkson on 17/9/18.

import Foundation
import Files

// Need File to be hashable for set processing to remove duplicates.
extension File: Hashable {
    public var hashValue: Int {
        return self.path.hashValue
    }
}
