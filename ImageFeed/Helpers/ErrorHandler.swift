import UIKit

struct ErrorHandler {
    static func printError(_ error: Error, origin: String, details: String? = nil) {
        var message = "[\(origin)]: \(error.localizedDescription)"
        if let details {
            message += ", \(details)"
        }
        print(message)
    }
}
