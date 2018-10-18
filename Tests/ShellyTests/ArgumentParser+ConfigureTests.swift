
//  Created by Derek Clarkson on 18/10/18.

import XCTest
import Nimble
@testable import Shelly
import Utility

class ArgumentParser_ConfigureTests: XCTestCase {

    var parser: ArgumentParser!

    override func setUp() {
        super.setUp()
        parser = ArgumentParser(usage: "", overview: "")
    }

    func testConfigureWithArgumentClasses() {

        let arguments = parser.configure(withArgumentClasses: [VerboseArgument.self])

        expect(arguments.count) == 1

        let arg = arguments[VerboseArgument.key]
        expect(arg).toNot(beNil())
        expect(arg).to(beAKindOf(VerboseArgument.self))

        expect { try self.parser.parse(["--verbose"]) }.toNot(throwError())
    }

    func testConfigureWithNilArgumentClasses() {
        let arguments = parser.configure(withArgumentClasses: nil)
        expect(arguments.isEmpty) == true
        expect { try self.parser.parse(["--verbose"]) }.to(throwError(ArgumentParserError.unknownOption("--verbose")))
    }

    func testConfigureWithSubCommandClasses() throws {

        let subCommands = try parser.configure(withSubCommandClasses: [TestSubCommand.self])

        expect(subCommands.count) == 1

        let command = subCommands["test"]
        expect(command).toNot(beNil())
        expect(command).to(beAKindOf(TestSubCommand.self))

        expect { try self.parser.parse(["test"]) }.toNot(throwError())
   }

    func testConfigureWithNilSubCommandClasses() throws {

        let subCommands = try parser.configure(withSubCommandClasses: nil)

        expect(subCommands.count) == 0

        expect { try self.parser.parse(["test"]) }.to(throwError(ArgumentParserError.unexpectedArgument("test")))

    }

}
