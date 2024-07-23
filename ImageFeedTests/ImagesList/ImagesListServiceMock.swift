@testable import ImageFeed
import Foundation

final class ImagesListServiceMock: ImagesListServiceProtocol {
    var photos: [Photo] = []
    
    func fetchPhotosNextPage() {
        let photo = Photo(id: "1",
                          size: CGSize(),
                          createdAt: nil,
                          welcomeDescription: nil,
                          regularImageURL: "https://api.unsplash.com",
                          fullImageURL: "https://api.unsplash.com",
                          isLiked: false)
        photos.append(photo)
        
        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }
}
