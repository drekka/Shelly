
//  Created by Derek Clarkson on 13/9/18.

import Basic

public protocol SubCommand: ProcessArgumentReader {

    var subcommand: String { get }
    var overview: String { get }

    init()
    func execute() throws
}
