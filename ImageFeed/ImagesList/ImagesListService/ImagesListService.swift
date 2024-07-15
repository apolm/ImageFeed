import UIKit

enum ImagesListServiceError: Error, LocalizedError {
    case failedToCreatePhotosRequest
    case failedToCreateLikeRequest
        
    var errorDescription: String? {
        switch self {
        case .failedToCreatePhotosRequest:
            "Failed to create photos request"
        case .failedToCreateLikeRequest:
            "Failed to create like request"
        }
    }
}

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    private var photosTask: URLSessionTask?
    private var likeTask: URLSessionTask?
    
    private let tokenStorage = OAuthTokenStorage.shared
    private let dateFormatter: ISO8601DateFormatter = {
        ISO8601DateFormatter()
    } ()
    
    private init() { }
  
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        
        guard photosTask == nil else {
            return
        }
        
        guard let token = tokenStorage.token else {
            ErrorHandler.printError(OAuthTokenError.noAccessToken,
                                    origin: "ImagesListService.fetchPhotosNextPage")
            return
        }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = photosRequest(token: token, page: nextPage) else {
            ErrorHandler.printError(ImagesListServiceError.failedToCreatePhotosRequest,
                                    origin: "ImagesListService.fetchPhotosNextPage")
            return
        }
        
        photosTask = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let photosResult):
                for photoResult in photosResult {
                    let photo = Photo(id: photoResult.id,
                                      size: CGSize(width: photoResult.width, height: photoResult.height),
                                      createdAt: dateFormatter.date(from: photoResult.createdAt),
                                      welcomeDescription: photoResult.description,
                                      regularImageURL: photoResult.urls.regular,
                                      fullImageURL: photoResult.urls.full,
                                      isLiked: photoResult.likedByUser)
                    self.photos.append(photo)
                }
                
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
            case .failure(let error):
                ErrorHandler.printError(error, origin: "ImagesListService.fetchPhotosNextPage")
            }
            
            self.lastLoadedPage = nextPage
            self.photosTask = nil
        }
        photosTask?.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard likeTask == nil else {
            return
        }
        
        guard let token = tokenStorage.token else {
            completion(.failure(OAuthTokenError.noAccessToken))
            return
        }
        
        let request = likeRequest(token: token, photoId: photoId, isLike: isLike)
        likeTask = URLSession.shared.mainQueueDataTask(for: request) { [weak self] (result: Result<Data, Error>) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
            
            self?.likeTask = nil
        }
        likeTask?.resume()
    }
    
    func clearData() {
        photos = []
        lastLoadedPage = nil
        photosTask?.cancel()
        photosTask = nil
        likeTask?.cancel()
        likeTask = nil
    }
    
    private func photosRequest(token: String, page: Int) -> URLRequest? {
        let url = Constants.defaultBaseURL.appendingPathComponent("photos")
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        urlComponents.queryItems = [URLQueryItem(name: "page", value: "\(page)")]
        
        guard let fullUrl = urlComponents.url else { return nil }
        
        var request = URLRequest(url: fullUrl)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    private func likeRequest(token: String, photoId: String, isLike: Bool) -> URLRequest {
        let url = Constants.defaultBaseURL
            .appendingPathComponent("photos")
            .appendingPathComponent(photoId)
            .appendingPathComponent("like")
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
}
