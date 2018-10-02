
//  Created by Derek Clarkson on 18/9/18.

import Files
import Foundation

/// Wrapper for files selected for processing.
public struct SelectedFile: CustomStringConvertible, Equatable, Hashable {

    public static func == (lhs: SelectedFile, rhs: SelectedFile) -> Bool {
        return lhs.file == rhs.file
    }

    public var hashValue: Int {
        return file.path.hashValue
    }

    public let file: File

    init(file: String) throws {
        self.file = try File(path: file)
    }

    init(file: File) {
        self.file = file
    }

    public var description: String {
        return file.path
    }
}
