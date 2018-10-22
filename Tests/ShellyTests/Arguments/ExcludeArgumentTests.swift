
//  Created by Derek Clarkson on 18/10/18.

import XCTest
import Shelly
import Utility
import Nimble

class ExcludeArgumentTests: XCTestCase {

    var parser: ArgumentParser!
    var arg: ExcludeArgument!

    override func setUp() {
        super.setUp()
        parser = ArgumentParser(usage: "", overview: "")
        arg = ExcludeArgument(argumentParser: parser)
    }

    func testParsesValue() throws {
        _ = try parser.parse(["--exclude", "abc"])
    }

    func testAllowsMultipleValues() throws {
        _ = try parser.parse(["--exclude", "abc", "def"])
    }

    func testRequiresValue() {
        expect { try self.parser.parse(["--exclude"]) }.to(throwError(ArgumentParserError.expectedValue(option: "--exclude")))
    }

    func testMap() throws {
        let results = try parser.parse(["--exclude", "abc"])
        try arg.map(results)

        expect(self.arg.excludeMasks).toNot(beNil())
        expect(self.arg.excludeMasks?.count) == 1
        expect(self.arg.excludeMasks?.contains("abc")) == true
    }

    func testMapWhenArgumentNotSet() throws {
        let results = try parser.parse([])
        try arg.map(results)
        expect(self.arg.excludeMasks).to(beNil())
    }
}
