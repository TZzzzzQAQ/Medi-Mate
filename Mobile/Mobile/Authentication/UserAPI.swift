//
//  UserAPI.swift
//  Mobile
//
//  Created by Lykheang Taing on 16/08/2024.
//


import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case serverError(String)
}

class UserAPIService {
    static let shared = UserAPIService()
    private let baseURL = Constant.apiSting
    
    private init() {}
    
    func request<T: Codable>(endpoint: String, method: String, body: [String: Any]? = nil) async throws -> T {
        guard let url = URL(string: baseURL + "/api/user/" + endpoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            print(data, response)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch {
                    throw APIError.decodingError(error)
                }
            } else {
                if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    throw APIError.serverError(errorResponse.msg)
                } else {
                    throw APIError.serverError("Unknown server error")
                }
            }
        } catch {
            throw APIError.networkError(error)
        }
    }
}

struct ErrorResponse: Codable {
    let code: Int
    let msg: String
}
