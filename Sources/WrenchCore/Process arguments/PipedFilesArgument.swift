
//  Created by Derek Clarkson on 18/9/18.

import Files
import Utility

struct PipedFilesArgument: CommandArgument, FileSourceFactory {

    static let argumentSyntax: String? = nil

    init(argumentParser _: ArgumentParser) {}

    var fileSources: [FileSource]? = nil

    func read(arguments _: ArgumentParser.Result) throws {
//        if toolbox.fileSourcesEmpty {
////            toolbox.add(fileSource: PipeFileSource())
//        }
    }
}
