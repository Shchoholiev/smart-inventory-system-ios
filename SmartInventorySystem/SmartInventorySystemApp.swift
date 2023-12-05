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
                            Text("Items")
                                .tabItem {
                                    Image(systemName: "rectangle.stack.fill")
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(Color.blue)
                                    Text("Items")
                                }
                            
                            Text("Shelves")
                                .tabItem {
                                    Image(systemName: "tray.2.fill")
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(Color.blue)
                                    Text("Shelves")
                                }
                            
                            if globalUser.roles.contains("Owner") {
                                GroupView()
                                    .tabItem {
                                        Image(systemName: "person.3.fill")
                                            .symbolRenderingMode(.palette)
                                            .foregroundStyle(Color.blue)
                                        Text("Group")
                                    }
                                
                                Text("Devices")
                                    .tabItem {
                                        Image(systemName: "cpu")
                                            .symbolRenderingMode(.palette)
                                            .foregroundStyle(Color.blue)
                                        Text("Devices")
                                    }
                            }
                            
                            UserProfileView()
                                .tabItem {
                                    Image(systemName: "person.crop.circle")
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(Color.blue)
                                    Text("Profile")
                                }
                            
                            if globalUser.roles.contains("Admin") {
                                Text("Manage users")
                                    .tabItem {
                                        Image(systemName: "person.crop.rectangle.stack.fill")
                                            .symbolRenderingMode(.palette)
                                            .foregroundStyle(Color.blue)
                                        Text("Manage users")
                                    }
                                
                                Text("Create Device")
                                    .tabItem {
                                        Image(systemName: "plus.circle.fill")
                                            .symbolRenderingMode(.palette)
                                            .foregroundStyle(Color.blue)
                                        Text("Create Device")
                                    }
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
