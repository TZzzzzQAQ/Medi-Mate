import SwiftUI
import CryptoKit

class RegisterViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var isRegistered = false
    
    private let apiService = UserAPIService.shared
    
    func resetRegistrationStatus() {
        isRegistered = false
    }
    
    func register() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "All fields are required"
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let hashedPassword = hashPassword(password)
            let _: EmptyResponse = try await apiService.request(
                endpoint: "register",
                method: "POST",
                body: ["email": email, "password": hashedPassword]
            )
            isRegistered = true
        } catch {
            if let apiError = error as? APIError, case .serverError(let message) = apiError {
                errorMessage = message
            } else {
                errorMessage = error.localizedDescription
            }
        }
        
        isLoading = false
    }
    
    private func hashPassword(_ password: String) -> String {
        let inputData = Data(password.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}

struct EmptyResponse: Codable {}
