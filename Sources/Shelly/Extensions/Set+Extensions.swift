//
//  Set+Extensions.swift
//  Shelly
//
//  Created by Derek Clarkson on 11/10/18.
//

import Basic
import Foundation

public extension Set where Element == RelativePath {

    public mutating func subtract(filesMatchingExpressions expressions: [NSRegularExpression]) {
        let filesToRemove = self.filter { file in
            return expressions.first { expression in
                let filename = file.asString
                return expression.rangeOfFirstMatch(in: filename, options: [], range: NSRange(location: 0, length: filename.count)).location != NSNotFound
                } != nil
        }
        self.subtract(filesToRemove)
    }
}
