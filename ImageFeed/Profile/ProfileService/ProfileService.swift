import UIKit

enum ProfileServiceError: Error, LocalizedError {
    case repeatedProfileRequest
    
    var errorDescription: String? {
        switch self {
        case .repeatedProfileRequest:
            "Repeated profile request"
        }
    }
}

final class ProfileService {
    static let shared = ProfileService()
    
    private(set) var profile: Profile?
    private var lastToken: String?
    private var task: URLSessionTask?
    
    private init() { }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard token != lastToken else {
            completion(.failure(ProfileServiceError.repeatedProfileRequest))
            return
        }
        
        task?.cancel()
        
        lastToken = token
        let request = profileRequest(token: token)
        task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let profileResult):
                let profile = Profile(profileResult: profileResult)
                self?.profile = profile
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
            
            self?.lastToken = nil
            self?.task = nil
        }
        
        task?.resume()
    }
    
    private func profileRequest(token: String) -> URLRequest {
        let url = Constants.defaultBaseURL.appendingPathComponent("me")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
