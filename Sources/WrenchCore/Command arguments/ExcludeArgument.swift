
//  Created by Derek Clarkson on 18/9/18.

import Utility
import Basic
import SwiftShell
import Foundation

class ExcludeArgument: CommandArgument {

    static let argumentSyntax = "[--exclude mask ...]"

    private let excludeMasksArgument: OptionArgument<[String]>

    var excludeMasks: [String]?
    
    required init(argumentParser: ArgumentParser) {
        excludeMasksArgument = argumentParser.add(option: "--exclude",
                                                  kind: [String].self,
                                                  usage: "Specifies a series of masks for excluding files. For example *.data will exclude data files.")
    }

    func parse(arguments: ArgumentParser.Result) throws {
        if let excludeMasks = arguments.get(excludeMasksArgument) {
            self.excludeMasks = excludeMasks
        }
    }
}
