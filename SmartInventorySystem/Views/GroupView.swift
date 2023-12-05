//
//  GroupView.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/4/23.
//

import SwiftUI

struct GroupView: View {
    private var groupId = GlobalUser.shared.groupId ?? ""
    @State private var groupName: String = ""
    @State private var groupDescription: String = ""
    @State private var users: [User] = []
    
    @State private var newUsername: String = ""
    
    @State private var errorMessage: String? = nil
    @State private var isEditMode: Bool = false
    @State private var isLoading = true
//    @State private var isLoading = false
    
    @State private var addUserCount = 0

    private var groupsService = GroupsService()
    private var usersService = UsersSerice()

    var body: some View {
        if isLoading {
            ProgressView()
            .onAppear {
                loadGroupData()
            }
        } else {
            VStack(spacing: 10) {
                HStack {
                    Text("Your Group")
                        .font(.title)
                    
                    Spacer()
                    
                    
                    if isEditMode {
                        Button(action: saveGroup) {
                            Text("Save")
                                .font(.system(size: 16, weight: .bold, design: .default))
                                .padding([.trailing, .leading], 20)
                                .padding([.top, .bottom], 10)
                                .foregroundColor(.white)
                                .background(.blue)
                                .opacity(isFormValid ? 1 : 0.5)
                                .cornerRadius(40)
                        }
                        .disabled(!isFormValid)
                    } else {
                        Button {
                            isEditMode = true
                        } label: {
                            Label("Edit", systemImage: "square.and.pencil")
                        }
                        .symbolRenderingMode(.palette)
                    }
                }
                .padding([.trailing, .leading], 25)
                .padding(.bottom, 0)
                
                Form {
                    Section(header: Text("Name")) {
                        TextField("Group Name", text: $groupName)
                            .disabled(!isEditMode)
                    }
                    
                    Section(header: Text("Description")) {
                        TextEditor(text: $groupDescription)
                            .disabled(!isEditMode)
                            .frame(minHeight: 100)
                    }
                }
                .frame(height: 280)
                
                if let message = errorMessage {
                    Text(message)
                        .foregroundColor(.red)
                        .padding([.trailing, .leading], 15)
                }
                
                HStack {
                    TextField("Email or phone", text: $newUsername)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: addUser) {
                        Image(systemName: "person.fill.badge.plus")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white)
                            .symbolEffect(.bounce, value: addUserCount)
                            
                        Text("Add User")
                            .foregroundColor(.white)
                    }
                    .padding([.trailing, .leading], 15)
                    .padding([.top, .bottom], 7)
                    .background(.blue)
                    .opacity(newUsername.isEmpty ? 0.5 : 1)
                    .cornerRadius(40)
                    .disabled(newUsername.isEmpty)
                }
                .padding([.leading, .trailing])
                
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(users, id: \.id) { user in
                            HStack {
                                HStack() {
                                    Text(user.name)
                                        .font(.headline)
                                    Text(user.email ?? "")
                                        .font(.subheadline)
                                    Text(user.phone ?? "")
                                        .font(.subheadline)
                                }

                                Spacer()

                                if GlobalUser.shared.id != user.id {
                                    Button(action: { deleteUser(user) }) {
                                        Image(systemName: "trash.circle.fill")
                                            .foregroundColor(.red)
                                            .font(.system(size: 24))
                                    }
                                } else {
                                    Button(action: { leaveGroup() }) {
                                        Image(systemName: "arrow.right.circle.fill")
                                            .foregroundColor(.yellow)
                                            .font(.system(size: 24))
                                    }
                                }
                            }
                            .padding([.top, .bottom], 10)
                            .padding([.leading, .trailing])
                            .background(Color.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
            .padding()
            .background(Color(UIColor.systemGroupedBackground))
        }
    }

    var isFormValid: Bool {
        !groupName.isEmpty
    }
    
    private func loadGroupData() {
        Task {
            do {
//                await GlobalUser.shared.setGroupId(nil)
                let group = try await groupsService.getGroup(groupId)
                groupName = group.name
                groupDescription = group.description ?? ""

                let fetchedUsers = try await groupsService.getGroupUsers(group.id)
                users = fetchedUsers

                isLoading = false
            } catch let httpError as HttpError {
                errorMessage = httpError.message
                isLoading = false
            }
        }
    }

    private func saveGroup() {
        Task {
            do {
                let group = Group("", groupName, groupDescription)
                _ = try await groupsService.updateGroup(groupId, group)
                groupName = group.name
                groupDescription = group.description ?? ""
                
                errorMessage = nil
                isEditMode = false
            } catch let httpError as HttpError {
                errorMessage = httpError.message
            }
        }
    }
    
    private func addUser() {
        addUserCount += 1
        Task {
            do {
                let user = try await usersService.getUser(newUsername)
                _ = try await groupsService.addUserToGroup(groupId, user.id)
                
                let fetchedUsers = try await groupsService.getGroupUsers(groupId)
                users = fetchedUsers
                print(users)
                
                newUsername = ""
                errorMessage = nil
                isEditMode = false
            } catch let httpError as HttpError {
                errorMessage = httpError.message
            }
        }
    }
    
    private func deleteUser(_ user: User) {
        Task {
            do {
                _ = try await groupsService.removeUserFromGroup(groupId, user.id)
                
                let fetchedUsers = try await groupsService.getGroupUsers(groupId)
                users = fetchedUsers
                
                errorMessage = nil
                isEditMode = false
            } catch let httpError as HttpError {
                errorMessage = httpError.message
            }
        }
    }

    private func leaveGroup() {
        Task {
            do {
                _ = try await groupsService.leaveGroup(groupId)
                
                
                
                errorMessage = nil
                isEditMode = false
            } catch let httpError as HttpError {
                errorMessage = httpError.message
            }
        }
    }
}

#Preview {
    GroupView()
}
