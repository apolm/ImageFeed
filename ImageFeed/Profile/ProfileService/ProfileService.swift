import UIKit

enum ProfileServiceError: Error {
    case repeatedProfileRequest
}

final class ProfileService {
    static let shared = ProfileService()
    
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
        task = URLSession.shared.mainQueueDataTask(for: request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let result = try SnakeCaseJSONDecoder().decode(ProfileResult.self, from: data)
                    let profile = Profile(profileResult: result)
                    completion(.success(profile))
                } catch {
                    completion(.failure(error))
                }
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
