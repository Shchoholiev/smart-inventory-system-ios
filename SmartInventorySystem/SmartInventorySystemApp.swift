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
    @State private var isLoading = true
    
    let groupsService = GroupsService()
    
    @State var groupClick = 0
    
    var body: some Scene {
        WindowGroup {
            if isLoading {
                ProgressView()
                .onAppear {
                    Task {
                        await HttpClient.shared.checkAuthentication()
                        isLoading = false
                    }
                }
            } else {
                if (httpClient.isAuthenticated) {
                    if globalUser.groupId != nil {
                        TabView {
                            GroupView()
                                .tabItem {
                                    Image(systemName: "person.3.fill")
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(Color.blue)
                                    Text("Group")
                                }
                            
                            Text("Second Tab")
                                .tabItem {
                                    Image(systemName: "cpu")
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(Color.blue)
                                    Text("Devices")
                                }
                        }
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
}
