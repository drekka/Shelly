
//  Created by Derek Clarkson on 13/9/18.

import Foundation
import Files

public protocol FileSource {
    func getFiles() throws -> Set<SelectedFile>
}
