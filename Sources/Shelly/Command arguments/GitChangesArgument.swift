
//  Created by Derek Clarkson on 18/9/18.

import Utility

public class GitChangesArgument: CommandArgument, FileSourceFactory {

    public static let argumentSyntax = "[--scan-git-changes]"

    private let scanGitChanges: OptionArgument<Bool>

    public var fileSources: [FileSource]? = nil

    public required init(argumentParser: ArgumentParser) {
        scanGitChanges = argumentParser.add(option: "--scan-git-changes",
                                            kind: Bool.self,
                                            usage: "Scans Git changed area for files to process.")
    }

    public func parse(arguments: ArgumentParser.Result) throws {
        if arguments.get(scanGitChanges) ?? false {
            self.fileSources = [GitChangesFileSource()]
        }
    }
}
