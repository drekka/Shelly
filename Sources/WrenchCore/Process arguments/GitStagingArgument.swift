
//  Created by Derek Clarkson on 18/9/18.

import Files
import Utility

struct GitStagingArgument: CommandArgument {
    static let argumentSyntax: String? = "[--scan-git-staging]"

    private let scanGitStaging: OptionArgument<Bool>

    init(argumentParser: ArgumentParser) {
        scanGitStaging = argumentParser.add(option: "--scan-git-staging",
                                            kind: Bool.self,
                                            usage: "Scans the Git staging area for files to process.")
    }

    func activate(arguments: ArgumentParser.Result, toolbox: Toolbox) throws {
        if arguments.get(scanGitStaging) ?? false {
            toolbox.add(fileSource: GitStagingFileSource())
        }
    }
}
