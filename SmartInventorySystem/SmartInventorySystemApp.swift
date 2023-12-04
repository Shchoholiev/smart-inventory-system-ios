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
    
    @State var showLogin: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if (httpClient.isAuthenticated) {
                Text("Hey")
            } else {
                if showLogin {
                    Text("Login")
                } else {
                    RegisterView(showLogin: $showLogin)
                }
            }
        }
    }
}
