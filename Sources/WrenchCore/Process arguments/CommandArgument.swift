
//  Created by Derek Clarkson on 18/9/18.

import Utility

public protocol CommandArgument: class {
    static var argumentSyntax: String? { get }
    init(argumentParser: ArgumentParser)
    func read(arguments: ArgumentParser.Result) throws
}

public protocol FileSourceFactory {
    var fileSources: [FileSource]? { get }
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
