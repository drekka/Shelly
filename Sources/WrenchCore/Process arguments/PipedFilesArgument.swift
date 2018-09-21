
//  Created by Derek Clarkson on 18/9/18.

import Files
import Utility

struct PipedFilesArgument: CommandArgument {
    static let argumentSyntax: String? = nil

    init(argumentParser _: ArgumentParser) {}

    func activate(arguments _: ArgumentParser.Result, toolbox: Toolbox) throws {
        if toolbox.fileSourcesEmpty {
            toolbox.addFileSource(PipeFileSource())
        }
    }
}
