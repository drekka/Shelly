
//  Created by Derek Clarkson on 18/9/18.

import Files
import Utility

struct GitChangesArgument: CommandArgument, FileSourceFactory {

    static let argumentSyntax: String? = "[--scan-git-changes]"

    private let scanGitChanges: OptionArgument<Bool>

    var fileSources: [FileSource]? = nil

    init(argumentParser: ArgumentParser) {
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
