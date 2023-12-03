//
//  AuthService.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/3/23.
//

import Foundation

class UsersSerice: ServiceBase {
    
    init() {
        super.init(url: "/users")
    }
    
    let jwtService = JwtTokensService()
    
    func register(_ registerModel: RegisterModel) async throws -> Bool {
        let tokens: TokensModel = try await HttpClient.shared.postAsync("\(baseUrl)/register", registerModel)
        jwtService.storeTokensInKeychain(tokens: tokens)
        await HttpClient.shared.setAuthenticated(true)
        
        return true
    }
}
