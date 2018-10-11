
//  Created by Derek Clarkson on 18/9/18.

import Utility

class GitStagingArgument: CommandArgument, FileSourceFactory {

    static let argumentSyntax = "[--scan-git-staging]"

    private let scanGitStaging: OptionArgument<Bool>

    var fileSources: [FileSource]? = nil

    required init(argumentParser: ArgumentParser) {
        scanGitStaging = argumentParser.add(option: "--scan-git-staging",
                                            kind: Bool.self,
                                            usage: "Scans the Git staging area for files to process.")
    }

    func parse(arguments: ArgumentParser.Result) throws {
        if arguments.get(scanGitStaging) ?? false {
            self.fileSources = [GitStagingFileSource()]
        }
    }
}
