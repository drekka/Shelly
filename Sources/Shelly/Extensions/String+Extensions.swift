//
//  String+Extensions.swift
//  Basic
//
//  Created by Derek Clarkson on 18/10/18.
//

import Foundation
import Basic

public extension String {

    public func resolve() -> AbsolutePath {
        switch self.first {
        case "/", "~":
            return AbsolutePath((self as NSString).expandingTildeInPath)
        default:
            return AbsolutePath(localFileSystem.currentDirectory, RelativePath(self))
        }
    }

    public func resolve() -> RelativePath {
        switch self.first {
        case "/", "~":
            return AbsolutePath((self as NSString).expandingTildeInPath).relative(to: localFileSystem.currentDirectory)
        default:
            return RelativePath(self)
        }
    }
}
