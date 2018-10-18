
//  Created by Derek Clarkson on 18/10/18.

import XCTest
import Shelly
import Nimble
import Utility

class ArgumentTests: XCTestCase {

    func testKeyOnStructArgument() {
        expect(ExcludeArgument.key) == "ExcludeArgument"
    }
}
