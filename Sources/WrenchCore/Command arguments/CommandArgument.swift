
//  Created by Derek Clarkson on 18/9/18.

import Utility

protocol CommandArgument: class, ProcessArgumentParser {
    static var argumentSyntax: String { get }
    init(argumentParser: ArgumentParser)
}

extension CommandArgument {
    static var key: String {
        return String(describing: self)
    }
}

extension Array where Element == CommandArgument.Type {

    var syntax: String {
        return self.compactMap { $0.argumentSyntax }.joined(separator: " ")
    }
}
