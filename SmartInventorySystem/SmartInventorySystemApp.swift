//
//  SmartInventorySystemApp.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/3/23.
//

import SwiftUI

@main
struct SmartInventorySystemApp: App {
    // Shared instances of HttpClient and GlobalUser to manage network requests and user information globally.
    @StateObject private var httpClient = HttpClient.shared
    @StateObject private var globalUser = GlobalUser.shared
    
    // State variables to manage login screen display and loading state.
    @State var showLogin: Bool = false
    @State private var isLoading = true
    
    let groupsService = GroupsService()
    
    var body: some Scene {
        WindowGroup {
            if isLoading {
                // Display a loading view with an app icon and a progress indicator while the app is loading.
                VStack {
                    Image("AppIconImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .cornerRadius(20)
                        .padding()
                    
                    ProgressView()
                    .onAppear {
                        // Check authentication status when the view appears.
                        Task {
                            await HttpClient.shared.checkAuthentication()
                            isLoading = false
                        }
                    }
                }
            } else {
                // Main content of the app, displayed after loading is complete.
                if (httpClient.isAuthenticated) {
                    // If the user is authenticated and part of a group, display the main tab view.
                    if globalUser.groupId != nil {
                        TabView {
                            
                            // Conditional tab views based on user roles.
                            // Admin users have additional tabs for user and device management.
                            if globalUser.roles.contains("Admin") {
                                NavigationStack {
                                    UsersView()
                                        .navigationDestination(for: User.self) { user in
                                            UserDetailsView(user: user)
                                        }
                                }
                                .tabItem {
                                    Image(systemName: "person.crop.rectangle.stack.fill")
                                        .symbolRenderingMode(.palette)
                                        .foregroundStyle(Color.blue)
                                    Text("Manage users")
                                }
                                
                                DeviceCreationView()
                                    .tabItem {
                                        Image(systemName: "plus.circle.fill")
                                            .symbolRenderingMode(.palette)
                                            .foregroundStyle(Color.blue)
                                        Text("Create Device")
                                    }
                            }
                            
                            NavigationStack {
                                ItemsView()
                                    .navigationDestination(for: Item.self) { item in
                                        ItemDetailsView(item: item)
                                    }
                            }
                            .tabItem {
                                Image(systemName: "rectangle.stack.fill")
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(Color.blue)
                                Text("Items")
                            }
                            
                            NavigationStack {
                                ShelvesView()
                                    .navigationDestination(for: Shelf.self) { shelf in
                                        ShelfDetailsView(shelf: shelf)
                                            .navigationTitle(shelf.name)
                                    }
                                    .navigationDestination(for: Item.self) { item in
                                        ItemDetailsView(item: item)
                                            .navigationTitle(item.name)
                                    }
                            }
                            .tabItem {
                                Image(systemName: "tray.2.fill")
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(Color.blue)
                                Text("Shelves")
                            }
                            
                            // Additional tabs for users with 'Owner' role.
                            if globalUser.roles.contains("Owner") {
                                GroupView()
                                    .tabItem {
                                        Image(systemName: "person.3.fill")
                                            .symbolRenderingMode(.palette)
                                            .foregroundStyle(Color.blue)
                                        Text("Group")
                                    }
                                
                                DevicesView()
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
                        }
                    } else {
                        // If the user is authenticated but not part of a group, display the group creation view.
                        GroupCreationView()
                    }
                } else {
                    // If the user is not authenticated, display login or register view based on `showLogin` state.
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
