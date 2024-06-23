import UIKit

enum ProfileImageServiceError: Error {
    case accessTokenNotDefined
    case repeatedProfileImageRequest
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
            completion(.failure(ProfileImageServiceError.accessTokenNotDefined))
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
        task = URLSession.shared.mainQueueDataTask(for: request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let result = try SnakeCaseJSONDecoder().decode(UserResult.self, from: data)
                    self?.avatarURL = result.profileImage.large
                    completion(.success(result.profileImage.large))
                    
                    NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: self)
                } catch {
                    completion(.failure(error))
                }
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

