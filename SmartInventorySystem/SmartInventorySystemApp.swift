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
    
    var body: some Scene {
        WindowGroup {
            if (httpClient.isAuthenticated) {
                Text("Hey")
            } else {
                RegisterView()
            }
        }
    }
}
