import Foundation

enum OAuthServiceError: Error {
    case failedToCreateTokenRequest
    case repeatedTokenRequest
}

final class OAuthService {
    static let shared = OAuthService()
    
    private var lastCode: String?
    private var task: URLSessionTask?
    
    private init() { }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard code != lastCode else {
            completion(.failure(OAuthServiceError.repeatedTokenRequest))
            return
        }
        
        task?.cancel()
        
        guard let request = tokenRequest(code: code) else {
            completion(.failure(OAuthServiceError.failedToCreateTokenRequest))
            return
        }
        
        lastCode = code
        task = URLSession.shared.mainQueueDataTask(for: request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let response = try SnakeCaseJSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    
                    let storage = OAuthTokenStorage()
                    storage.token = response.accessToken
                    
                    completion(.success(response.accessToken))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
            
            self?.lastCode = nil
            self?.task = nil
        }
        
        task?.resume()
    }
    
    private func tokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: Constants.tokenURLString) else {
            assertionFailure("Failed to create URL for token request")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            assertionFailure("Failed to create URL for token request")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}
