import Foundation

public struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let regularImageURL: String
    let fullImageURL: String
    var isLiked: Bool
    
    public init(id: String, size: CGSize, createdAt: Date?, welcomeDescription: String?, regularImageURL: String, fullImageURL: String, isLiked: Bool) {
        self.id = id
        self.size = size
        self.createdAt = createdAt
        self.welcomeDescription = welcomeDescription
        self.regularImageURL = regularImageURL
        self.fullImageURL = fullImageURL
        self.isLiked = isLiked
    }
}
