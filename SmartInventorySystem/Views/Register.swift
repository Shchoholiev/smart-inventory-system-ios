//
//  Register.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/3/23.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var registrationModel = RegistrationModel()

    var body: some View {
        VStack {
            Text("Register")
                .font(.largeTitle)

            TextField("Name", text: $registrationModel.name)
                .padding(12)
                .foregroundColor(.primary)
                .cornerRadius(7)
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding(7)

            TextField("Email", text: $registrationModel.email)
                .padding(12)
                .foregroundColor(.primary)
                .cornerRadius(7)
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding(7)

            SecureField("Password", text: $registrationModel.password)
                .padding(12)
                .foregroundColor(.primary)
                .cornerRadius(7)
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding(7)

            Button(action: registerUser) {
                Text("Register")
                    .frame(minWidth: 0, maxWidth: 100)
                    .font(.system(size: 18, weight: .bold, design: .default))
                    .padding()
                    .foregroundColor(.white)
                    .background(isFormValid ? .blue : .gray)
                    .cornerRadius(40)
            }
            .disabled(!isFormValid)
            .padding()
        }
        .padding(30)
    }
    
    var isFormValid: Bool {
        (!registrationModel.email.isEmpty
         || !registrationModel.phone.isEmpty)
        && !registrationModel.password.isEmpty
    }

    func registerUser() {
        // Handle user registration logic here
        // Access user input through registrationModel.username, registrationModel.email, etc.
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
