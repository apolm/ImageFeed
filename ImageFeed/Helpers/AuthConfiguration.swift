import Foundation

enum Constants {
    static let accessKey = "3_b3lAtCz0vKeoISoBPHVkGXE2ZXksLqdSCeqHjc_jo"
    static let secretKey = "uc3UCX4F9AY81AUhavsR_bsY9k4V0WllU1id4UdaNgw"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let authorizeURLString = "https://unsplash.com/oauth/authorize"
    static let tokenURLString = "https://unsplash.com/oauth/token"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authorizeURLString: String
    let tokenURLString: String
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 defaultBaseURL: Constants.defaultBaseURL,
                                 authorizeURLString: Constants.authorizeURLString,
                                 tokenURLString: Constants.tokenURLString
        )
    }
}
