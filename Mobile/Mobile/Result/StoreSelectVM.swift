//
//  StoreSelectVM.swift
//  Mobile
//
//  Created by Jabin on 2024/9/6.
//

import Foundation

@MainActor

class StoreSelectVM: ObservableObject {
    @Published var productLocation: ProductLocationData?
    @Published var isLoading = false
    @Published var errorMessage: String?
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func fetchProduct(productId: String, pharmacyId: Int) async {
        isLoading = true
        errorMessage = nil
        do {
            let fetchedProduct = try await networkService.findProduct(productId: productId, pharmacyId: pharmacyId)
            let decoder = JSONDecoder()
            let response = try decoder.decode(ProductLocationResponse.self, from: Data(fetchedProduct.utf8))
            DispatchQueue.main.async {
                self.productLocation = response.data
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}
