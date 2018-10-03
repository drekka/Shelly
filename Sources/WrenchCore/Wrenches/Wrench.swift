
//  Created by Derek Clarkson on 13/9/18.

public protocol Wrench: ArgumentReader {

    var subcommand: String { get }
    var overview: String { get }

    var fileFilter: (SelectedFile) -> Bool { get }

    init()

    func execute(onFiles files: Set<SelectedFile>) throws
}
