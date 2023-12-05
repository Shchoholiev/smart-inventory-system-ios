//
//  UserProfileView.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/4/23.
//

import SwiftUI

struct UserProfileView: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("User Profile")
                .font(.title)
                .padding(.bottom, 0)
            
            Form {
                Section(header: Text("Name")) {
                    Text(GlobalUser.shared.name ?? "")
                }
                
                Section(header: Text("Email")) {
                    Text(GlobalUser.shared.email ?? "")
                }
                
                Section(header: Text("Phone")) {
                    Text(GlobalUser.shared.phone ?? "")
                }
            }
            .frame(height: 310)
            
            Button {
                HttpClient.shared.logout()
            } label: {
                Text("Logout")
                    .font(.system(size: 18, weight: .bold, design: .default))
                    .padding()
                    .padding([.trailing, .leading])
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(40)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemGroupedBackground))
    }
}

#Preview {
    UserProfileView()
}
