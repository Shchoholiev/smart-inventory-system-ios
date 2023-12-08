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
                VStack {
                    Image("AppIconImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .cornerRadius(20)
                        .padding()
                    
                    ProgressView()
                    .onAppear {
                        Task {
                            await HttpClient.shared.checkAuthentication()
                            isLoading = false
                        }
                    }
                }
            } else {
                if (httpClient.isAuthenticated) {
                    if globalUser.groupId != nil {
                        TabView {
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
                            
                            if globalUser.roles.contains("Admin") {
                                Text("Manage users")
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
