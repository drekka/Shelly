
//  Created by Derek Clarkson on 18/9/18.

import Utility
import Files

struct PipedFilesArgument: CommandArgument {
    
    static let argumentSyntax: String? = nil
    
    init(argumentParser: ArgumentParser) {}
    
    func activate(arguments: ArgumentParser.Result, toolbox: Toolbox) throws {
        if toolbox.fileSourcesEmpty {
            toolbox.addFileSource(PipeFileSource())
        }
    }
}

