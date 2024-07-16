import Foundation

struct UrlsResult: Codable {
    let regular: String
    let full: String
}

struct PhotoResult: Codable {
    let id: String
    let height: Int
    let width: Int
    let createdAt: String
    let description: String?
    let urls: UrlsResult
    let likedByUser: Bool
}
