
//  Created by Derek Clarkson on 18/9/18.

import Utility

class VerboseArgument: CommandArgument {
    
    static let argumentSyntax = "[--verbose]"
    
    private let verboseArgument: OptionArgument<Bool>
    
    required init(argumentParser: ArgumentParser) {
        verboseArgument = argumentParser.add(option: "--verbose",
                                             kind: Bool.self,
                                             usage: "Turns on verbose output for debugging purposes.")
    }
    
    func parse(arguments: ArgumentParser.Result) throws {
        if arguments.get(verboseArgument) ?? false {
            wrenchLog("Enabling verbose output")
            verbose = true
        }
    }
}
