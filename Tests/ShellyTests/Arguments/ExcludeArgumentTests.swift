
//  Created by Derek Clarkson on 18/10/18.

import XCTest
import Shelly
import Utility
import Nimble

class ExcludeArgumentTests: XCTestCase {

    var parser: ArgumentParser!

    override func setUp() {
        super.setUp()
        parser = ArgumentParser(usage: "", overview: "")
    }

    func testParsesValue() throws {
        _ = ExcludeArgument(argumentParser: parser)
        _ = try parser.parse(["--exclude", "abc"])
    }

    func testAllowsMultipleValues() throws {
        _ = ExcludeArgument(argumentParser: parser)
        _ = try parser.parse(["--exclude", "abc", "def"])
    }

    func testRequiresValue() {
        _ = ExcludeArgument(argumentParser: parser)
        expect { try self.parser.parse(["--exclude"]) }.to(throwError(ArgumentParserError.expectedValue(option: "--exclude")))
    }

    func testMap() throws {
        let arg = ExcludeArgument(argumentParser: parser)
        let results = try parser.parse(["--exclude", "abc"])
        try arg.map(results)

        expect(arg.excludeMasks).toNot(beNil())
        expect(arg.excludeMasks?.count) == 1
        expect(arg.excludeMasks?.contains("abc")) == true
    }
}
