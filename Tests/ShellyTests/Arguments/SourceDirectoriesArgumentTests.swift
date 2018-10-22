
//  Created by Derek Clarkson on 18/10/18.

import XCTest
import Shelly
import Utility
import Nimble
import Basic

class SourceDirectoriesArgumentTests: XCTestCase {

    var parser: ArgumentParser!
    var arg: SourceDirectoriesArgument!

    var tmpDir: AbsolutePath!

    override func setUp() {
        super.setUp()
        parser = ArgumentParser(usage: "", overview: "")
        arg = SourceDirectoriesArgument(argumentParser: parser)
        tmpDir = localFileSystem.switchToTmpDirectory()
        localFileSystem.create(testFile: "testfile1", inDirectory: "sub1")
        localFileSystem.create(testFile: "testfile2", inDirectory: "sub2")
    }

    override func tearDown() {
        try! localFileSystem.removeFileTree(tmpDir)
        super.tearDown()
    }

    func testParsesValue() throws {
        _ = try parser.parse(["--source-dirs", "sub1", "sub2"])
    }

    func testRequiresValue() {
        expect { try self.parser.parse(["--source-dirs"]) }.to(throwError(ArgumentParserError.expectedValue(option: "---source-dirs")))
    }

    func testMap() throws {
        let results = try parser.parse(["--source-dirs", "sub1", "sub2"])
        try arg.map(results)

        let files = try arg.fileSources?.flatMap { try $0.getFiles() }
        expect(files).toNot(beNil())
        expect(files?.count) == 2
        expect(files).to(contain([
            RelativePath("sub1/testfile1"),
            RelativePath("sub2/testfile2"),
            ]))
    }
}
