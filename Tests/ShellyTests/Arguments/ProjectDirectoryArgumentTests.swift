
//  Created by Derek Clarkson on 18/10/18.

import XCTest
import Shelly
import Utility
import Nimble
import Basic

class ProjectDirectoryArgumentTests: XCTestCase {

    var parser: ArgumentParser!
    var arg: ProjectDirectoryArgument!

    var tmpDir: AbsolutePath!

    override func setUp() {
        super.setUp()
        parser = ArgumentParser(usage: "", overview: "")
        arg = ProjectDirectoryArgument(argumentParser: parser)
        tmpDir = localFileSystem.switchToTmpDirectory()
    }

    override func tearDown() {
        try! localFileSystem.removeFileTree(tmpDir)
        super.tearDown()
    }

    func testParsesValue() throws {
        _ = try parser.parse(["--project-dir", tmpDir.asString])
    }

    func testMultipleValuesThrows() throws {
        expect { try self.parser.parse(["--project-dir", "abc", "def"]) }.to(throwError(ArgumentParserError.unexpectedArgument("def")))
    }

    func testRequiresValue() {
        expect { try self.parser.parse(["--project-dir"]) }.to(throwError(ArgumentParserError.expectedValue(option: "---project-dir")))
    }

    func testMap() throws {
        let results = try parser.parse(["--project-dir", tmpDir.asString])
        try arg.map(results)

        // BY default we get /private/var/... back as the local directory, do we use
        // resolvingSymlinksInPath() to resolve it back to /var/... for comparing.
        let result = URL(fileURLWithPath: localFileSystem.currentDirectory.asString).resolvingSymlinksInPath().path

        expect(result) == tmpDir.asString
    }

    func testMapWhenArgumentNotSet() throws {
        try localFileSystem.setCurrentWorkingDirectory("~".resolve())
        let results = try parser.parse([])
        try arg.map(results)
        let result = localFileSystem.currentDirectory
        expect(result) == "~".resolve()
    }
}
