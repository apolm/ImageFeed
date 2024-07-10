import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let regularImageURL: String
    let largeImageURL: String
    var isLiked: Bool
    
    init(photoResult: PhotoResult) {
        id = photoResult.id
        size = CGSize(width: photoResult.width, height: photoResult.height)
        createdAt = photoResult.createdAt
        welcomeDescription = photoResult.description
        regularImageURL = photoResult.urls.regular
        largeImageURL = photoResult.urls.full
        isLiked = photoResult.likedByUser
    }
}