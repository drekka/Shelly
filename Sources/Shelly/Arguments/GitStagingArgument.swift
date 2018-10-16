
//  Created by Derek Clarkson on 18/9/18.

import Utility

public class GitStagingArgument: Argument, FileSourceFactory {

    public static let argumentSyntax = "[--scan-git-staging]"

    private let scanGitStaging: OptionArgument<Bool>

    public var fileSources: [FileSource]? = nil

    public required init(argumentParser: ArgumentParser) {
        scanGitStaging = argumentParser.add(option: "--scan-git-staging",
                                            kind: Bool.self,
                                            usage: "Scans the Git staging area for files to process.")
    }

    public func map(_ parseResults: ArgumentParser.Result) throws {
        if parseResults.get(scanGitStaging) ?? false {
            self.fileSources = [GitStagingFileSource()]
        }
    }
}
