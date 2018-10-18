//
//  ArgumentCollectionTests.swift
//  ShellyTests
//
//  Created by Derek Clarkson on 18/10/18.
//

import XCTest
import Shelly
import Nimble
import Utility

class ArgumentCollectionTests: XCTestCase, ArgumentCollection {

    var arguments: [String : Argument] = [:]
    var parser: ArgumentParser!

    override func setUp() {
        super.setUp()
        parser = ArgumentParser(usage: "", overview: "")
        arguments = parser.configure(withArgumentClasses: [ExcludeArgument.self])
    }

    func testMap() throws {
        let results = try parser.parse(["--exclude", "abc*"])
        try map(results)
        let arg: ExcludeArgument = try getArgument()
        expect(arg.excludeMasks) == ["abc*"]
    }

    func testGetArgumentThrowsWhenNotFound() throws {
        let results = try parser.parse([])
        try map(results)
        expect { return try self.getArgument() as GitStagingArgument }.to(throwError(ShellyError.argumentNotFound))
    }

}
