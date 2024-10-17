import SwiftUI

struct UserInfo: Codable {
    let userId: String
    let birthYear: Int
    let userWeight: Int
    let userHeight: Int
}
struct UserInfoResponse: Codable {
    let code: Int
    let msg: String?
    let data: UserInfo
}
import SwiftUI

struct AccountView: View {
    @ObservedObject var authViewModel: AuthenticationView
    @Environment(\.fontSizeMultiplier) private var fontSizeMultiplier
    
    @State private var showingEditProfile = false
    @State private var showingChangePassword = false
    @State private var userInfo: UserInfo?
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                ScrollView {
                    VStack(spacing: 20) {
                        profileHeader
                        userInfoCards
                        actionButtons
                        Spacer(minLength: 20)
                    }
                    .padding()
                }
                
                logoutButton
                    .padding(.horizontal)
                    .padding(.bottom, 50)
                
               
            }
            .background(Color(.systemBackground))
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: fetchUserInfo)
        }
        .sheet(isPresented: $showingEditProfile) {
            NavigationView {
                EditProfileView(authViewModel: authViewModel, userInfo: $userInfo)
            }
        }
        .sheet(isPresented: $showingChangePassword) {
            NavigationView {
                ChangePasswordView(authViewModel: authViewModel)
            }
        }
    }
    
    private var profileHeader: some View {
        HStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.pink)
                    .frame(width: 80, height: 80)
                Text(authViewModel.userName.prefix(1).uppercased())
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(authViewModel.userName)
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(authViewModel.userEmail)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var userInfoCards: some View {
        VStack(spacing: 16) {
            if let userInfo = userInfo {
                infoCard(title: "Birth Year", value: "\(userInfo.birthYear)", systemImage: "calendar")
                infoCard(title: "Weight", value: "\(userInfo.userWeight) kg", systemImage: "scalemass")
                infoCard(title: "Height", value: "\(userInfo.userHeight) cm", systemImage: "ruler")
            } else if isLoading {
                ProgressView()
            } else if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.subheadline)
            }
        }
    }
    
    private func infoCard(title: String, value: String, systemImage: String) -> some View {
        HStack {
            Image(systemName: systemImage)
                .foregroundColor(.blue)
                .frame(width: 30)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.headline)
            }
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: { showingEditProfile = true }) {
                Label("Edit Profile", systemImage: "pencil")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(action: { showingChangePassword = true }) {
                Label("Change Password", systemImage: "lock.rotation")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
    
    private var logoutButton: some View {
        Button(action: {
            Task {
                do {
                    try await authViewModel.logout()
                } catch {
                    print("Error logging out: \(error.localizedDescription)")
                }
            }
        }) {
            Text("Logout")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red.opacity(0.1))
                .foregroundColor(.red)
                .cornerRadius(10)
        }
    }
    
    private var tabBar: some View {
        HStack {
            ForEach(["house", "doc.text", "map", "person.circle"], id: \.self) { imageName in
                Image(systemName: imageName)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 10)
        .background(Color(.secondarySystemBackground))
    }
    
    private func fetchUserInfo() {
        isLoading = true
        errorMessage = nil
        
        UserInfoAPI.shared.fetchUserInfo(userId: authViewModel.userId) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let userInfo):
                    self.userInfo = userInfo
                case .failure(let error):
                    self.errorMessage = "Error fetching user info: \(error.localizedDescription)"
                }
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(authViewModel: AuthenticationView())
    }
}
