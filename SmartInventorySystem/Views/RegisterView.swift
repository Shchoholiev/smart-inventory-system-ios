//
//  Register.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/3/23.
//

import SwiftUI

struct RegisterView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var password: String = ""
    
    @State private var errorMessage: String? = nil
    
    @Binding var showLogin: Bool
    
    private var usersService = UsersService()
    
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
    
    var isFormValid: Bool {
        (!email.isEmpty || !phone.isEmpty) && !password.isEmpty
    }

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

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(showLogin: .constant(false))
    }
}
