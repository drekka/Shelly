
//  Created by Derek Clarkson on 18/9/18.

import Utility
import Basic
import SwiftShell
import Foundation

public class ExcludeArgument: Argument {

    public static let argumentSyntax = "[--exclude mask ...]"

    private let excludeMasksArgument: OptionArgument<[String]>

    public var excludeMasks: [String]?
    
    public required init(argumentParser: ArgumentParser) {
        excludeMasksArgument = argumentParser.add(option: "--exclude",
                                                  kind: [String].self,
                                                  usage: "Specifies a series of masks for excluding files. For example *.data will exclude data files.")
    }

    public func map(_ parseResults: ArgumentParser.Result) throws {
        if let excludeMasks = parseResults.get(excludeMasksArgument) {
            self.excludeMasks = excludeMasks
        }
    }
}
