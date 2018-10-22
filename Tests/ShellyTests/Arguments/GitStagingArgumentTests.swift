
//  Created by Derek Clarkson on 18/10/18.

import XCTest
import Shelly
import Utility
import Nimble

class GitStagingArgumentTests: XCTestCase {

    var parser: ArgumentParser!
    var arg: GitStagingArgument!

    override func setUp() {
        super.setUp()
        parser = ArgumentParser(usage: "", overview: "")
        arg = GitStagingArgument(argumentParser: parser)
    }

    func testParsesValue() throws {
        _ = try parser.parse(["--scan-git-staging"])
    }

    func testRejectsValues() throws {
        expect { try self.parser.parse(["--scan-git-staging", "abc", "def"]) }
            .to(throwError(ArgumentParserError.unexpectedArgument("abc")))
    }

    func testMap() throws {
        let results = try parser.parse(["--scan-git-staging"])
        try arg.map(results)

        let fileSources = arg.fileSources
        expect(fileSources).toNot(beNil())
        expect(fileSources?.first).to(beAKindOf(GitStagingFileSource.self))
    }

    func testMapWhenArgumentNotSet() throws {
        let results = try parser.parse([])
        try arg.map(results)
        expect(self.arg.fileSources).to(beNil())
    }
}
