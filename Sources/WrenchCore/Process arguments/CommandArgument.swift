
//  Created by Derek Clarkson on 18/9/18.

import Utility

protocol CommandArgument {
    static var argumentSyntax: String? { get }
    init(argumentParser: ArgumentParser)
    func activate(arguments: ArgumentParser.Result, toolbox: Toolbox) throws
}
