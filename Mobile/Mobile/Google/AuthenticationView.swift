import Foundation
import FirebaseCore
import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseAuth

class AuthenticationView: ObservableObject {
    @Published var isLoginSuccessed = false
    @Published var loginError = ""
    @Published var currentUser: User?
    @Published var userEmail: String = ""
    @Published var userName: String = ""
    @Published var userPicURL: URL?
    @Published var userId: String = ""
    @Published var token: String = ""
    
    @Published var errorMessage: String?
    
    
    private let apiService = UserAPIService.shared
    @Published var cartManager: CartManager?
    init() {
        self.currentUser = Auth.auth().currentUser
        self.cartManager = cartManager
    }

    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: Application_utility.rootViewController) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = "Google Sign-In error: \(error.localizedDescription)"
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken else {
                self?.errorMessage = "Failed to get user information from Google Sign-In"
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: user.accessToken.tokenString)
            
            self?.authenticateWithFirebase(credential: credential, user: user)
        }
    }
    
    private func authenticateWithFirebase(credential: AuthCredential, user: GIDGoogleUser) {
        Auth.auth().signIn(with: credential) { [weak self] authResult, error in
            if let error = error {
                self?.errorMessage = "Firebase authentication failed: \(error.localizedDescription)"
                return
            }
            
            self?.currentUser = authResult?.user
            self?.isLoginSuccessed = true
            
            self?.updateUserInfo(user: user)
            self?.storeUserInDatabase(user: user)
        }
    }
    
    private func updateUserInfo(user: GIDGoogleUser) {
        self.userEmail = user.profile?.email ?? ""
        self.userName = user.profile?.name ?? ""
        self.userPicURL = user.profile?.imageURL(withDimension: 200)
        self.userId = user.userID ?? ""
    }
    
    private func storeUserInDatabase(user: GIDGoogleUser) {
        guard let email = user.profile?.email,
              let googleId = user.userID,
              let username = user.profile?.name,
              let userPic = user.profile?.imageURL(withDimension: 200)?.absoluteString else {
            self.errorMessage = "Failed to get complete user information"
            return
        }
        
        Task {
            do {
                let response: GoogleLoginResponseAPI = try await apiService.request(
                    
                    endpoint: "google-login",
                    method: "POST",
                    body: [
                        "email": email,
                        "googleId": googleId,
                        "username": username,
                        "userPic": userPic
                    ]
                )
                await MainActor.run {
                    if response.code == 1 { // Assuming code 1 means success
                        // Store response data
                        self.userId = response.data.userId
                        self.userName = response.data.username
                        self.userEmail = response.data.email
//                        self.userPicURL = response.data.userPicUR< ?? ""
                        self.token = response.data.token
                        AuthManager.shared.token = response.data.token
                        
//                        // Update AuthenticationView properties
//                        authViewModel.isLoginSuccessed = true
//                        authViewModel.userEmail = self.userEmail
//                        authViewModel.userName = self.username
//                        authViewModel.userPicURL = URL(string: self.userPic)
//                        authViewModel.userId = self.userId
                        
                        // Print response data to console
                        self.printLoginResponse()
                    } else {
                        // Handle case where login was not successful
                        loginError = response.msg ?? "Login failed for unknown reason"
                        print("Login Error: \(loginError)")
                    }
                }
            } catch {
                await MainActor.run {
                    self.handleLoginError(error)
                }
            }
//                await MainActor.run {
//                    print("User successfully stored in database")
//                    print("Google Login Response: \(response)")
//                    // Update user information if needed based on the response
//                    // For example:
//                    // self.userId = response.userId ?? self.userId
//                }
//            } catch {
//                // Error handling code...
//            }
        }
    }
    private func handleLoginError(_ error: Error) {
        if let apiError = error as? APIError {
            switch apiError {
            case .serverError(let message):
                loginError = "Server error: \(message)"
            case .invalidResponse:
                loginError = "Invalid response from server"
            case .decodingError:
                loginError = "Error decoding server response"
            default:
                loginError = "An unexpected error occurred"
            }
        } else {
            loginError = "An unexpected error occurred: \(error.localizedDescription)"
        }
        print("Login Error: \(loginError)")
        print("Full error details: \(error)")
    }
    
    func logout() {
            do {
                try Auth.auth().signOut()
                GIDSignIn.sharedInstance.signOut()
                
                // Clear user info
                isLoginSuccessed = false
                currentUser = nil
                userEmail = ""
                userName = ""
                userPicURL = nil
                userId = ""
                token = ""
                
                // Post a notification that logout occurred
                NotificationCenter.default.post(name: .userDidLogout, object: nil)
            } catch {
                errorMessage = "Failed to sign out: \(error.localizedDescription)"
            }
        }
    private func printLoginResponse() {
        let responseData = """
        Login Successful!
        User ID: \(userId)
        Username: \(userName)
        Email: \(userEmail)

        Token: \(token)
        """
        print(responseData)
    }
    
    
}



struct GoogleLoginResponse: Codable {
    let userId: String?
    let email: String?
    let googleId : String?
    let username : String?
    let nickname: String?
    let userPic : String?
    let token : String?
    
    // Add other fields as needed based on your API response
}

struct GoogleLoginResponseAPI: Codable {
    let code: Int
    let msg: String?
    let data: UserData
}

