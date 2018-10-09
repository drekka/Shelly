//  Created by Derek Clarkson on 12/9/18.

import SwiftShell

public func wrenchLog(_ message: String, _ args: CVarArg...) {
    main.stdout.print(String(format: message, args))
}

public func wrenchLogError(_ message: String, _ args: CVarArg...) {
    main.stderror.print("Error !")
    main.stderror.print(String(format: message, args))
    main.stderror.print("Use 'wrench --help' for command syntax help.")
    main.stderror.print("")
}

var verbose: Bool = false

public func wrenchVerboseLog(_ message: String, _ args: CVarArg...) {
    guard verbose else { return }
    main.stdout.print("🔦 " + String(format: message, args))
}

