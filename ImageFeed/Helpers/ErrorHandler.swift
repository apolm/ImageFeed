import UIKit

struct ErrorHandler {
    func errorMessage(from error: Error) -> String {
        switch error {
        case NetworkError.httpStatusCode(let code):
            return "Error \(code) when receiving token."
        default:
            return error.localizedDescription
        }
    }
}
