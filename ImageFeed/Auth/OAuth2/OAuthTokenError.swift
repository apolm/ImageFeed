import Foundation

enum OAuthTokenError: Error, LocalizedError {
    case noAccessToken
    
    var errorDescription: String? {
        switch self {
        case .noAccessToken:
            "No access token"
        }
    }
}
