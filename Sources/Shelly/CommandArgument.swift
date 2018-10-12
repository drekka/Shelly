
//  Created by Derek Clarkson on 18/9/18.

import Utility

public protocol CommandArgument: ParsedResultMapper {
    static var argumentSyntax: String { get }
    init(argumentParser: ArgumentParser)
}

public extension CommandArgument {
    static var key: String {
        return String(describing: self)
    }
}

public extension Array where Element == CommandArgument.Type {

    var syntax: String {
        return self.compactMap { $0.argumentSyntax }.joined(separator: " ")
    }
}
