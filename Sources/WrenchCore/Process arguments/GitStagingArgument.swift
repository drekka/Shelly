
//  Created by Derek Clarkson on 18/9/18.

import Files
import Utility

class GitStagingArgument: CommandArgument, FileSourceFactory {

    static let argumentSyntax: String? = "[--scan-git-staging]"

    private let scanGitStaging: OptionArgument<Bool>

    var fileSources: [FileSource]? = nil

    required init(argumentParser: ArgumentParser) {
        scanGitStaging = argumentParser.add(option: "--scan-git-staging",
                                            kind: Bool.self,
                                            usage: "Scans the Git staging area for files to process.")
    }

    func read(arguments: ArgumentParser.Result) throws {
        if arguments.get(scanGitStaging) ?? false {
            self.fileSources = [GitStagingFileSource()]
        }
    }
}
