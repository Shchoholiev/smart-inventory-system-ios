//
//  SmartInventorySystemApp.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/3/23.
//

import SwiftUI

@main
struct SmartInventorySystemApp: App {
    @StateObject private var httpClient = HttpClient.shared
    @StateObject private var globalUser = GlobalUser.shared
    
    @State var showLogin: Bool = false
    
    let groupsService = GroupsService()
    
    var body: some Scene {
        WindowGroup {
            if (httpClient.isAuthenticated) {
                if globalUser.groupId != nil {
                    Text("groups")
                } else {
                    GroupCreationView()
                }
            } else {
                if showLogin {
                    LoginView(showLogin: $showLogin)
                } else {
                    RegisterView(showLogin: $showLogin)
                }
            }
        }
    }
}
