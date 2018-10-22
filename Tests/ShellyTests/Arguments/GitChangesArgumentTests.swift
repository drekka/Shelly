
//  Created by Derek Clarkson on 18/10/18.

import XCTest
import Shelly
import Utility
import Nimble

class GitChangesArgumentTests: XCTestCase {

    var parser: ArgumentParser!
    var arg: GitChangesArgument!

    override func setUp() {
        super.setUp()
        parser = ArgumentParser(usage: "", overview: "")
        arg = GitChangesArgument(argumentParser: parser)
    }

    func testParsesValue() throws {
        _ = try parser.parse(["--scan-git-changes"])
    }

    func testRejectsValues() throws {
        expect { try self.parser.parse(["--scan-git-changes", "abc", "def"]) }
        .to(throwError(ArgumentParserError.unexpectedArgument("abc")))
    }

    func testMap() throws {
        let results = try parser.parse(["--scan-git-changes"])
        try arg.map(results)

        let fileSources = arg.fileSources
        expect(fileSources).toNot(beNil())
        expect(fileSources?.first).to(beAKindOf(GitChangesFileSource.self))
    }

    func testMapWhenArgumentNotSet() throws {
        let results = try parser.parse([])
        try arg.map(results)
        expect(self.arg.fileSources).to(beNil())
    }
}
