import Foundation

struct OAuthTokenResponseBody: Decodable {
    let token: String
    
    private enum CodingKeys: String, CodingKey {
        case token = "access_token"
    }
}
