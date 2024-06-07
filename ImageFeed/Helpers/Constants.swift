import Foundation

enum Constants {
    static let accessKey = "3_b3lAtCz0vKeoISoBPHVkGXE2ZXksLqdSCeqHjc_jo"
    static let secretKey = "uc3UCX4F9AY81AUhavsR_bsY9k4V0WllU1id4UdaNgw"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
}

enum WebViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
