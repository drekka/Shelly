
//  Created by Derek Clarkson on 15/10/18.

import XCTest
import Nimble
import Shelly

class RelativePathArgumentTests: XCTestCase {

    func testRelativePathArgumentStoresPath() throws {
        let path = try RelativePathArgument(argument: "abc")
        expect(path.path.asString) == "abc"
    }
}
