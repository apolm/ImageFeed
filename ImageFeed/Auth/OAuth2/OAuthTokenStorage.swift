import Foundation

final class OAuthTokenStorage {
    var token: String? {
        get {
            userDefaults.string(forKey: Keys.token.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.token.rawValue)
        }
    }
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case token
    }
}
