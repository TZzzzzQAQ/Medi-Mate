import Foundation
import SwiftUI

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var authViewModel: AuthenticationView
    @Binding var userInfo: UserInfo?
    
    @State private var selectedBirthYear: Int
    @State private var selectedWeight: Int
    @State private var selectedHeight: Int
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    // Define the ranges for your pickers
    let birthYearRange = 1900...Calendar.current.component(.year, from: Date())
    let weightRange = 20...300 // kg
    let heightRange = 100...250 // cm
    
    init(authViewModel: AuthenticationView, userInfo: Binding<UserInfo?>) {
        self.authViewModel = authViewModel
        self._userInfo = userInfo
        
        // Initialize the selected values
        let currentYear = Calendar.current.component(.year, from: Date())
        _selectedBirthYear = State(initialValue: userInfo.wrappedValue?.birthYear ?? currentYear - 30)
        _selectedWeight = State(initialValue: userInfo.wrappedValue?.userWeight ?? 70)
        _selectedHeight = State(initialValue: userInfo.wrappedValue?.userHeight ?? 170)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                Picker("Birth Year", selection: $selectedBirthYear) {
                    ForEach(birthYearRange.reversed(), id: \.self) { year in
                        Text(String(year)).tag(year)
                    }
                }
                
                Picker("Weight (kg)", selection: $selectedWeight) {
                    ForEach(weightRange, id: \.self) { weight in
                        Text("\(weight) kg").tag(weight)
                    }
                }
                
                Picker("Height (cm)", selection: $selectedHeight) {
                    ForEach(heightRange, id: \.self) { height in
                        Text("\(height) cm").tag(height)
                    }
                }
            }
            
            if isLoading {
                ProgressView()
            } else if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            
            Button("Save Changes") {
                updateProfile()
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        })
    }
    
    private func updateProfile() {
        let updatedUserInfo = UserInfo(
            userId: authViewModel.userId,
            birthYear: selectedBirthYear,
            userWeight: selectedWeight,
            userHeight: selectedHeight
        )
        
        isLoading = true
        errorMessage = nil
        
        UserInfoAPI.shared.updateUserInfo(userInfo: updatedUserInfo) { result in
            isLoading = false
            switch result {
            case .success:
                userInfo = updatedUserInfo
                presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }
}
