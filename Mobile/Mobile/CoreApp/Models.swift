//
//  ProductModel.swift
//  Mobile
//
//  Created by Jabin on 2024/8/10.
//

import Foundation
import UIKit
import MapKit



// Mediction Model


struct ResponseData: Codable {
    let text: String
}

struct Product: Codable, Identifiable{
    let id: String
    let name: String
    let imageURL: String
}

struct Location: Identifiable, Codable,Hashable {
    let id : Int
    let name_store: String
    let name: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct LocationsData: Codable {
    let locations: [Location]
}

enum SearchError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case invalidResponse
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        }
    }
}


struct APIResponse<T: Codable>: Codable {
    let code: Int
    let msg: String?
    let data: T
}

struct Medicine: Codable, Identifiable {
    let commonUse: String?
    let directions: String?
    let generalInformation: String?
    let imageSrc: String
    let ingredients: String?
    let manufacturerName: String?
    let productId: String
    let productName: String
    let productPrice: String
    let warnings: String?
    var id: String { productId }
    var intProductId: Int? {
        return Int(productId)
    }
    static func == (lhs: Medicine, rhs: Medicine) -> Bool {
            return lhs.id == rhs.id
        }
}

struct SearchResponse: Codable {
    let data: SearchData
}

struct SearchData: Codable {
    let records: [Medicine]
    let total: Int
}

struct ProductDetails: Codable {
    let productId: String
    let productName: String
    let productPrice: String
    let manufacturerName: String
    let generalInformation: String?
    let warnings: String?
    let commonUse: String?
    let ingredients: String?
    let directions: String?
    let imageSrc: String
    let summary: String
}


struct Comparison: Codable{
    let productId: String
    let productName: String
    let imageSrc: String
    let productPrice: String
    let commonUse: String
    let warnings: String
    let difference: String
}

struct LocationRequest: Codable {
    let productId: String
    let pharmacyId: Int
}
struct ProductLocationData: Codable, Equatable {
    let pharmacyName: String
    let stockQuantity: Int
    let shelfNumber: String
    let shelfLevel: Int
}
struct ProductLocationResponse: Codable{
    let code: Int
    let msg: String?
    let data: ProductLocationData
}
enum StoreLocation: String {
    case a = "A", b = "B", c = "C", d = "D", e = "E"
}

struct Store: Identifiable, Hashable {
    let id: Int
    let name: String
}

let stores: [Store] = [
    Store(id: 1, name: "New Market"),
    Store(id: 2, name: "Manakua"),
    Store(id: 3, name: "Mount Albert"),
    Store(id: 4, name: "Albany"),
    Store(id: 5, name: "CBD")
]
