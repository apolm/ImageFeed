import UIKit

enum ProfileImageServiceError: Error, LocalizedError {
    case repeatedProfileImageRequest
    
    var errorDescription: String? {
        switch self {
        case .repeatedProfileImageRequest:
            "Repeated profile image request"
        }
    }
}

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private(set) var avatarURL: String?
    private var lastToken: String?
    private var lastUsername: String?
    private var task: URLSessionTask?
    
    private let tokenStorage = OAuthTokenStorage()
    
    private init() { }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let token = tokenStorage.token else {
            completion(.failure(OAuthTokenError.noAccessToken))
            return
        }
        
        guard token != lastToken,
              username != lastUsername else {
            completion(.failure(ProfileImageServiceError.repeatedProfileImageRequest))
            return
        }
        
        task?.cancel()
        
        lastToken = token
        lastUsername = username
        let request = profileImageRequest(token: token, username: username)
        task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            switch result {
            case .success(let userResult):
                self?.avatarURL = userResult.profileImage.large
                completion(.success(userResult.profileImage.large))
                NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: self)
            case .failure(let error):
                completion(.failure(error))
            }
            
            self?.lastToken = nil
            self?.lastUsername = nil
            self?.task = nil
        }
        
        task?.resume()
    }
    
    private func profileImageRequest(token: String, username: String) -> URLRequest {
        let url = Constants.defaultBaseURL
            .appendingPathComponent("users")
            .appendingPathComponent(username)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

