
//  Created by Derek Clarkson on 15/10/18.

import XCTest
import Nimble
import Shelly
import Basic

class DirectoryFileSourceTests: XCTestCase {

    var dfs: DirectoryFileSource!

    override func setUp() {

        super.setUp()

//        FileSystem.set(projectDirectory: AbsolutePath())

        let path = RelativePath("../File sources")
        dfs = DirectoryFileSource(directory: path)
    }

    func testGetFilesReturnsFiles() throws {
        let files = try dfs.getFiles()
        expect(files.count) == 5

    }


}
