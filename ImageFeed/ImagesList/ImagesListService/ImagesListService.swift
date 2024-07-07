import UIKit

enum ImagesListServiceError: Error, LocalizedError {
    case failedToCreatePhotosRequest
        
    var errorDescription: String? {
        switch self {
        case .failedToCreatePhotosRequest:
            "Failed to create photos request"
        }
    }
}

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    
    private let tokenStorage = OAuthTokenStorage()
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        
        guard task == nil else {
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
        
        task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let photosResult):
                photosResult.forEach { self?.photos.append(Photo(photoResult: $0)) }
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
            case .failure(let error):
                ErrorHandler.printError(error, origin: "ImagesListService.fetchPhotosNextPage")
            }
            
            self?.lastLoadedPage = nextPage
            self?.task = nil
        }
        
        task?.resume()
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
}
