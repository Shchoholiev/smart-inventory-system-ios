//
//  Register.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/3/23.
//

import SwiftUI

/// `RegisterView` is a SwiftUI view for handling user registration.
/// It provides text fields for user input (name, email, phone, password) and buttons for registration and switching to the login view.
struct RegisterView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var password: String = ""
    
    @State private var errorMessage: String? = nil
    @Binding var showLogin: Bool
    
    private var usersService = UsersService()
    
    /// Initializes a new `RegisterView` with a binding to control the login view display.
    /// - Parameter showLogin: A binding to a Boolean value that determines whether to show the login view.
    public init(showLogin: Binding<Bool>) {
        self._showLogin = showLogin
    }

    var body: some View {
        VStack {
            Text("Register")
                .font(.largeTitle)

            TextField("Name", text: $name)
                .padding(12)
                .foregroundColor(.primary)
                .cornerRadius(7)
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding(7)

            TextField("Email", text: $email)
                .padding(12)
                .foregroundColor(.primary)
                .cornerRadius(7)
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding(7)

            TextField("Phone", text: $phone)
                .padding(12)
                .foregroundColor(.primary)
                .cornerRadius(7)
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding(7)

            SecureField("Password", text: $password)
                .padding(12)
                .foregroundColor(.primary)
                .cornerRadius(7)
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding(7)
            
            HStack {
                Button(action: registerUser) {
                    Text("Register")
                        .frame(minWidth: 0, maxWidth: 100)
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .padding()
                        .foregroundColor(.white)
                        .background(.blue)
                        .opacity(isFormValid ? 1 : 0.5)
                        .cornerRadius(40)
                }
                .disabled(!isFormValid)
                .padding()
                
                Button(action: {
                    showLogin = true
                }) {
                    Text("Login")
                        .foregroundColor(.blue)
                        .underline()
                }
                .padding()
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding(30)
    }
    
    /// A computed property that checks if the form is valid.
    /// The form is valid if either the email or phone is non-empty and the password is non-empty.
    var isFormValid: Bool {
        (!email.isEmpty || !phone.isEmpty) && !password.isEmpty
    }

    /// Handles the user registration process.
    /// It creates a `RegisterModel` with user inputs and calls the `register` method on `UsersService`.
    /// It also handles error messages by updating `errorMessage`.
    func registerUser() {
        let registerModel = RegisterModel(name, email, phone, password)
        Task {
            do {
                _ = try await usersService.register(registerModel)
                errorMessage = nil
            } catch let httpError as HttpError {
                errorMessage = httpError.message
            }
        }
    }
}

//MARK: - Preview
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(showLogin: .constant(false))
    }
}
