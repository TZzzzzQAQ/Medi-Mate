import Foundation
import UIKit

protocol NetworkServiceProtocol {
    func textSearch(page: Int, pageSize: Int, productName: String, manufacture: String) async throws -> String
    func imageSearch(image: UIImage) async throws -> String
    func fetchProductDetails(productId: String) async throws -> String
    func compareProducts(productIds: [String]) async throws -> String
    func findProduct(productId: String, pharmacyId: Int) async throws -> String
}

class NetworkService: NetworkServiceProtocol {
    private func createURL(endpoint: String, queryItems: [URLQueryItem]? = nil) throws -> URL {
        var components = URLComponents(string: "\(Constant.apiSting)/api/\(endpoint)")
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        
        return url
    }
    
    func textSearch(page: Int, pageSize: Int, productName: String, manufacture: String) async throws -> String {
        let queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "pageSize", value: String(pageSize)),
            URLQueryItem(name: "productName", value: productName),
            URLQueryItem(name: "manufacture", value: manufacture)
        ]
        
        let url = try createURL(endpoint: "products", queryItems: queryItems)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    func imageSearch(image: UIImage) async throws -> String {
        let url = try createURL(endpoint: "message/image")
        let boundary = UUID().uuidString
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        if let imageData = image.jpegData(compressionQuality: 0.7) {
            data.append(imageData)
        }
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = data

        let (imageData, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return String(data: imageData, encoding: .utf8) ?? ""
    }
    
    func fetchProductDetails(productId: String) async throws -> String {
        let queryItems = [URLQueryItem(name: "productId", value: productId)]
        let url = try createURL(endpoint: "products/productDetail", queryItems: queryItems)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    func compareProducts(productIds: [String]) async throws -> String {
        let url = try createURL(endpoint: "message/comparison")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(AuthManager.shared.token)", forHTTPHeaderField: "Authorization")
        
        let body = ["productId": productIds]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return String(data: data, encoding: .utf8) ?? ""
    }

    func findProduct(productId: String, pharmacyId: Int) async throws -> String {
        let url = try createURL(endpoint: "products/productLocation")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = LocationRequest(productId: productId, pharmacyId: pharmacyId)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return String(data: data, encoding: .utf8) ?? ""
    }
}
