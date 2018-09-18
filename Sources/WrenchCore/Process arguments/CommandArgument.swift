
//  Created by Derek Clarkson on 18/9/18.

import Utility

protocol CommandArgument {
    init(argumentParser: ArgumentParser)
    func activate(arguments: ArgumentParser.Result, toolbox: Toolbox) throws
}
