//
//  ChangePassWordView.swift
//  Mobile
//
//  Created by Lykheang Taing on 28/08/2024.
//

import Foundation
import Foundation
import SwiftUI

struct ChangePasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var authViewModel: AuthenticationView
    
    @State private var oldPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmNewPassword: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var successMessage: String?
    
    var body: some View {
        Form {
            Section(header: Text("Change Password")) {
                SecureField("Old Password", text: $oldPassword)
                SecureField("New Password", text: $newPassword)
                SecureField("Confirm New Password", text: $confirmNewPassword)
            }
            
            if isLoading {
                ProgressView()
            } else if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
            } else if let success = successMessage {
                Text(success)
                    .foregroundColor(.green)
            }
            
            Button("Update Password") {
                updatePassword()
            }
            .disabled(oldPassword.isEmpty || newPassword.isEmpty || confirmNewPassword.isEmpty || newPassword != confirmNewPassword)
        }
        .navigationTitle("Change Password")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("Cancel") {
            presentationMode.wrappedValue.dismiss()
        })
    }
    
    private func updatePassword() {
        let passwordUpdate = PasswordUpdate(
            email: authViewModel.userEmail,
            oldPassword: oldPassword,
            newPassword: newPassword
        )
        
        isLoading = true
        errorMessage = nil
        successMessage = nil
        
        UserInfoAPI.shared.updatePassword(passwordUpdate: passwordUpdate) { result in
            isLoading = false
            switch result {
            case .success:
                successMessage = "Password updated successfully"
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    presentationMode.wrappedValue.dismiss()
                }
            case .failure(let error):
                errorMessage = error.localizedDescription
            }
        }
    }
}

struct PasswordUpdate: Codable {
    let email: String
    let oldPassword: String
    let newPassword: String
}
