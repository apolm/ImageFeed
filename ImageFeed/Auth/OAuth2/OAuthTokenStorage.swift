import Foundation
import SwiftKeychainWrapper

final class OAuthTokenStorage {
    var token: String? {
        get {
            keychain.string(forKey: Keys.token.rawValue)
        }
    }
    
    private let keychain = KeychainWrapper.standard
    private enum Keys: String {
        case token
    }
    
    func setToken(_ newValue: String) -> Bool {
        keychain.set(newValue, forKey: Keys.token.rawValue)
    }
}
