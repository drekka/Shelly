
//  Created by Derek Clarkson on 18/9/18.

import Files
import Utility

class PipedFilesArgument: CommandArgument, FileSourceFactory {

    static let argumentSyntax: String? = nil

    required init(argumentParser _: ArgumentParser) {}

    var fileSources: [FileSource]? = nil

    func read(arguments _: ArgumentParser.Result) throws {
//        if toolbox.fileSourcesEmpty {
////            toolbox.add(fileSource: PipeFileSource())
//        }
    }
}
