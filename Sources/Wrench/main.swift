
import Foundation
import WrenchCore

do {
    let mechanic = Mechanic()
    mechanic.setup()
    try mechanic.run()
} catch let error {
    wrenchLogError(String(describing: error))
    exit(1)
}
