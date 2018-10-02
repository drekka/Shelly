
import Foundation
import WrenchCore

do {
    try Mechanic().run()
} catch let error {
    wrenchLogError(String(describing: error))
    exit(1)
}
