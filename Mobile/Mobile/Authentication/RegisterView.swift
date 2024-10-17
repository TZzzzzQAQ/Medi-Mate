//
//  RegisterView.swift
//  Mobile
//
//  Created by Jabin on 2024/8/6.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.fontSizeMultiplier) private var fontSizeMultiplier

    @StateObject private var viewModel = RegisterViewModel()
        
    private var showSuccessAlert: Binding<Bool> {
        Binding(
            get: { viewModel.isRegistered },
            set: { _ in viewModel.resetRegistrationStatus() }
        )
    }

    var body: some View {
        VStack {
            Text("Create Account")
                .scalableFont(size: 34, weight: .bold)
                .foregroundColor(.black)
                .padding(.top, 50)
            
            VStack(spacing: 15) {
                CustomTextField(placeholder: "Email", text: $viewModel.email)
                CustomSecureField(placeholder: "Password", text: $viewModel.password)
                CustomSecureField(placeholder: "Confirm Password", text: $viewModel.confirmPassword)
            }
            .padding(.horizontal, 32)
            .padding()
            
            Button {
                Task {
                    await viewModel.register()
                }
            } label: {
                Text("Register")
                    .scalableFont(size: 18, weight: .semibold)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.vertical)
            .padding(.horizontal, 32)
            .disabled(viewModel.isLoading)
            
            if viewModel.isLoading {
                ProgressView()
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .scalableFont(size: 14)
                    .foregroundColor(.red)
                    .padding()
            }
            Spacer()
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .alert("Registration Successful", isPresented: showSuccessAlert) {
            Button("OK") { dismiss() }
        }
    }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    @Environment(\.fontSizeMultiplier) private var fontSizeMultiplier
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .scalableFont(size: 16)
                    .foregroundStyle(Color.gray)
                    .padding(.leading, 10)
            }
            TextField("", text: $text)
                .scalableFont(size: 16)
                .foregroundColor(.black)
                .padding(12)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
        }
    }
}

struct CustomSecureField: View {
    var placeholder: String
    @Binding var text: String
    @Environment(\.fontSizeMultiplier) private var fontSizeMultiplier
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .scalableFont(size: 16)
                    .foregroundStyle(Color.gray)
                    .padding(.leading, 10)
            }
            SecureField("", text: $text)
                .scalableFont(size: 16)
                .foregroundColor(.black)
                .padding(12)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
        }
    }
}

#Preview {
    RegisterView()
}
