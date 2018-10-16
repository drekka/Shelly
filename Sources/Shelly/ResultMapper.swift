
//  Created by Derek Clarkson on 17/10/18.

import Utility

public protocol ResultMapper: class {
    func map(_ parseResults: ArgumentParser.Result) throws
}

public extension ResultMapper {

    /// Empty implementation.
    func map(_ parseResults: ArgumentParser.Result) throws {}
}

