
//  Created by Derek Clarkson on 18/9/18.

import Utility

class GitChangesArgument: CommandArgument, FileSourceFactory {

    static let argumentSyntax = "[--scan-git-changes]"

    private let scanGitChanges: OptionArgument<Bool>

    var fileSources: [FileSource]? = nil

    required init(argumentParser: ArgumentParser) {
        scanGitChanges = argumentParser.add(option: "--scan-git-changes",
                                            kind: Bool.self,
                                            usage: "Scans Git changed area for files to process.")
    }

    func read(arguments: ArgumentParser.Result) throws {
        if arguments.get(scanGitChanges) ?? false {
            wrenchLog("Scanning Git changes")
        }
    }
}
