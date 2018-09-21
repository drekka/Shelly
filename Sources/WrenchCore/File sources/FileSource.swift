
//  Created by Derek Clarkson on 13/9/18.

import Files
import Foundation

public protocol FileSource {
    func getFiles() throws -> Set<SelectedFile>
}
