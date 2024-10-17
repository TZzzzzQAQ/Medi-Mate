import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @ObservedObject var authViewModel: AuthenticationView
    @State private var showRegister = false
    @Environment(\.fontSizeMultiplier) private var fontSizeMultiplier
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("Welcome to Medimate")
                    .scalableFont(size: 28, weight: .bold)
                
                TextField("Email", text: $viewModel.email)
                    .scalableFont(size: 16)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal, 20)
                
                SecureField("Password", text: $viewModel.password)
                    .scalableFont(size: 16)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal, 20)
                
                Button {
                    Task {
                        await viewModel.login(authViewModel: authViewModel)
                    }
                } label: {
                    Text("Sign In")
                        .scalableFont(size: 18, weight: .semibold)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 40)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 1, y: 5)
                }
                .disabled(viewModel.isLoading)
                
                Button {
                    authViewModel.signInWithGoogle()
                } label: {
                    HStack {
                        Image(.googleBrandsSolid)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                        
                        Text("Sign in with Google")
                            .scalableFont(size: 16, weight: .bold)
                            .foregroundColor(.black)
                    }
                    .frame(width: 250, height: 50)
                    .background(Color.white)
                    .cornerRadius(8)
                }
                .padding()
                .shadow(radius: 2)
                
                if !viewModel.loginError.isEmpty {
                    Text(viewModel.loginError)
                        .scalableFont(size: 14)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Button {
                    showRegister.toggle()
                } label: {
                    Text("Not have an account? Register")
                        .scalableFont(size: 16, weight: .bold)
                        .foregroundColor(.black)
                }
                .padding(.top)
            }
            .ignoresSafeArea()
            .sheet(isPresented: $showRegister) {
                RegisterView()
            }
        }
        .environment(\.fontSizeMultiplier, fontSizeMultiplier)
    }
}

// Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(authViewModel: AuthenticationView())
    }
}
