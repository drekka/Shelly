
//  Created by Derek Clarkson on 18/10/18.

import Shelly
import Utility

class MockSubCommand: SubCommand {

    var arguments: [String : Argument] = [:]

    required init() {}

    var configureCalled: Bool = false
    func configure(_ commandParser: ArgumentParser) throws -> String {
        let cmd = "test"
        arguments = try configure(commandParser, subCommand: cmd, overview: "")
        configureCalled = true
        return cmd
    }

    var executeCalled: Bool = false
    func execute() throws {
        executeCalled = true
    }
}
