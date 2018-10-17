
//  Created by Derek Clarkson on 18/9/18.

import Utility

public protocol Argument: ArgumentMapable {
    static var argumentSyntax: String { get }
    init(argumentParser: ArgumentParser)
}

public extension Argument {
    static var key: String {
        return String(describing: self)
    }
}

