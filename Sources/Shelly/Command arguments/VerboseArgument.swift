
//  Created by Derek Clarkson on 18/9/18.

import Utility

public class VerboseArgument: CommandArgument {
    
    public static let argumentSyntax = "[--verbose]"
    
    private let verboseArgument: OptionArgument<Bool>
    
    public required init(argumentParser: ArgumentParser) {
        verboseArgument = argumentParser.add(option: "--verbose",
                                             kind: Bool.self,
                                             usage: "Turns on verbose output for debugging purposes.")
    }
    
    public func parse(arguments: ArgumentParser.Result) throws {
        if arguments.get(verboseArgument) ?? false {
            ShellCommand.log("Enabling verbose output")
            ShellCommand.verbose = true
        }
    }
}
