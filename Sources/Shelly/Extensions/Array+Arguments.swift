
//  Created by Derek Clarkson on 17/10/18.

import Foundation
import Basic

public extension Array where Element == Argument.Type {

    var syntax: String {
        return self.compactMap { $0.argumentSyntax }.joined(separator: " ")
    }
}
