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
    
    @State private var errorMessage: String? = nil
    @State private var isEditMode: Bool = false
    @State private var isLoading = true

    private var groupsService = GroupsService()

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
}

#Preview {
    GroupView()
}
