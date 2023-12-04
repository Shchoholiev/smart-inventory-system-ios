//
//  CreateGroupView.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/3/23.
//

import SwiftUI

struct GroupCreationView: View {
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var errorMessage: String? = nil

    private var groupsService = GroupsService()

    var body: some View {
        VStack(spacing: 10) {
            Text("Create Group")
                .font(.title)
                .padding(.bottom, 0)

            Text("If you want to join a group provide your email or phone to the owner of the group.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding([.leading, .trailing], 17)

            Form {
                Section(header: Text("Name")) {
                    TextField("Group Name", text: $name)
                }

                Section(header: Text("Description")) {
                    TextEditor(text: $description)
                        .frame(minHeight: 100)
                }
            }
            .frame(height: 280)
            
            if let message = errorMessage {
                Text(message)
                    .foregroundColor(.red)
            }
            
            Button(action: createGroup) {
                Text("Create Group")
                    .frame(minWidth: 0, maxWidth: 120)
                    .font(.system(size: 18, weight: .bold, design: .default))
                    .padding()
                    .foregroundColor(.white)
                    .background(.blue)
                    .opacity(isFormValid ? 1 : 0.5)
                    .cornerRadius(40)
            }
            .disabled(!isFormValid)
            .padding()
            
            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    var isFormValid: Bool {
        !name.isEmpty
    }

    private func createGroup() {
        let group = Group("", name, description)

        Task {
            do {
                _ = try await groupsService.createGroup(group)
                errorMessage = nil
            } catch let httpError as HttpError {
                errorMessage = httpError.message
            }
        }
    }
}

struct GroupCreationView_Previews: PreviewProvider {
    static var previews: some View {
        GroupCreationView()
    }
}
