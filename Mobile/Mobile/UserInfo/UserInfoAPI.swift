import Foundation

class UserInfoAPI {
    static let shared = UserInfoAPI()
    private let baseURL = Constant.apiSting
    
    private init() {}
    
    func fetchUserInfo(userId: String, completion: @escaping (Result<UserInfo, Error>) -> Void) {
        let endpoint = "\(baseURL)/api/userinfo?userId=\(userId)"
        performGetRequest(endpoint: endpoint) { (result: Result<UserInfoResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateUserInfo(userInfo: UserInfo, completion: @escaping (Result<Void, Error>) -> Void) {
        let endpoint = "\(baseURL)/userinfo/updateUserInfo"
        performRequestWithBody(endpoint: endpoint, method: "PUT", body: userInfo) { (result: Result<EmptyResponse, Error>) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updatePassword(passwordUpdate: PasswordUpdate, completion: @escaping (Result<Void, Error>) -> Void) {
        let endpoint = "\(baseURL)/user/updatePassword"
        performRequestWithBody(endpoint: endpoint, method: "PATCH", body: passwordUpdate) { (result: Result<EmptyResponse, Error>) in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func performGetRequest<T: Decodable>(endpoint: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(AuthManager.shared.token)", forHTTPHeaderField: "Authorization")
        
        performRequest(request: request, completion: completion)
    }
    
    private func performRequestWithBody<T: Encodable, U: Decodable>(endpoint: String, method: String, body: T, completion: @escaping (Result<U, Error>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(AuthManager.shared.token)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }
        
        performRequest(request: request, completion: completion)
    }
    
    private func performRequest<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
