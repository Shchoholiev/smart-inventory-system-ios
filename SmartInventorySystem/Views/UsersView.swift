//
//  UsersView.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/8/23.
//

import SwiftUI

struct UsersView: View {
    private var groupId = GlobalUser.shared.groupId ?? ""
    @State private var users: [User] = []
    
    @State private var searchText = ""
    @State private var errorMessage: String? = nil
    @State private var isLoading = true

    private var usersService = UsersService()
    
    var body: some View {
        VStack {
            if isLoading {
                // Used to make full screen gray when loading
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    Spacer()
                }
                .background(Color(UIColor.systemGroupedBackground))
            } else {
                ScrollView {
                    VStack(spacing: 10) {
                        
                        ForEach($users, id: \.id) { $user in
                            HStack(alignment: .top) {
                                VStack(alignment: .leading) {
                                    if let name = user.name, !name.isEmpty {
                                        Text(name)
                                            .font(.headline)
                                    }
                                    
                                    if let email = user.email, !email.isEmpty {
                                        Text(email)
                                            .font(.subheadline)
                                    }
                                    
                                    if let phone = user.phone, !phone.isEmpty {
                                        Text(phone)
                                            .font(.subheadline)
                                    }
                                    
                                    Text(formatRolesForDisplay(user.roles))
                                        .font(.headline)
                                        .foregroundStyle(.gray)
                                }
                                
                                Spacer()
                                
                                NavigationLink(value: user) {
                                    Image(systemName: "info.circle.fill")
                                        .foregroundStyle(.blue)
                                        .font(.system(size: 24))
                                }
                            }
                            .padding([.top, .bottom], 13)
                            .padding([.leading, .trailing], 17)
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .cornerRadius(10)
                        }
                    }
                    .padding([.leading, .trailing, .bottom])
                    .padding([.top], 5)
                    .background(Color(UIColor.systemGroupedBackground))
                }
                .background(Color(UIColor.systemGroupedBackground))
            }
        }
        .onAppear {
            loadData()
        }
    }
    
    private func formatRolesForDisplay(_ roles: [Role]) -> String {
        let roleNames = roles.map { $0.name }
        return roleNames.joined(separator: ", ")
    }
    
    private func loadData() {
        Task {
            do {
                let usersPage = try await usersService.getUsersPage(size: 100)
                self.users = usersPage.items

                isLoading = false
            } catch let httpError as HttpError {
                errorMessage = httpError.message
                isLoading = false
            }
        }
    }
}

#Preview {
    UsersView()
}
