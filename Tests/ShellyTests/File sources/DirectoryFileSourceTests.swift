
//  Created by Derek Clarkson on 15/10/18.

import XCTest
import Nimble
import Shelly
import Basic

class DirectoryFileSourceTests: XCTestCase {

    var tmpDir: URL!

    override func setUp() {

        super.setUp()

        tmpDir = localFileSystem.switchToTmpDirectory()
        localFileSystem.create(testFile: "testfile1")
        localFileSystem.create(testFile: "testfile2", inDirectory: "sub")
    }

    override func tearDown() {
        try? FileManager.default.removeItem(at: tmpDir)
        super.tearDown()
    }

    func testGetFilesReturnsFiles() throws {
        let dfs = DirectoryFileSource(directory: RelativePath("."))
        let files = try dfs.getFiles()
        expect(files.count) == 3
        expect(files).to(contain(
            RelativePath("testfile1"),
            RelativePath("sub"),
            RelativePath("sub/testfile2")
        ))
    }

    func testGetFilesWithFilterReturnsFiles() throws {
        let dfs = DirectoryFileSource(directory: RelativePath(".")) { $0.components.last == "testfile2" }
        let files = try dfs.getFiles()
        expect(files.count) == 1
        expect(files).to(contain(
            RelativePath("sub/testfile2")
        ))
    }

    func testGetFilesWhenPathNotExists() {
        let dfs = DirectoryFileSource(directory: RelativePath(".doesNotExist"))
        expect(try dfs.getFiles()).to(throwError { error in
            guard case ShellyError.folderNotFound(let folder) = error,
                case folder.basename = ".doesNotExist" else {
                fail("Wrong error \(error)")
                return
            }
        })
    }

    func testGetFilesWhenNotADirectory() {
        let dfs = DirectoryFileSource(directory: RelativePath("testfile1"))
        expect(try dfs.getFiles()).to(throwError { error in
            guard case ShellyError.notAFolder(let folder) = error,
                case folder.basename = "testfile1" else {
                    fail("Wrong error \(error)")
                    return
            }
        })
    }
}
