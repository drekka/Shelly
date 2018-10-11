//
//  RelativePathArgumentTests.swift
//  WrenchTests
//
//  Created by Derek Clarkson on 10/10/18.
//

import XCTest
import Nimble
@testable import WrenchCore
import Basic

class RelativePathArgumentTests: XCTestCase {

    func testStoresConvertedPath() throws {
        let path = try RelativePathArgument(argument: "abc")
        let result = path.path
        expect(result.asString) == "abc"
    }
}
