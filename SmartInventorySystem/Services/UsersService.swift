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
    
    func login(_ loginModel: LoginModel) async throws -> Bool {
        let tokens: TokensModel = try await HttpClient.shared.postAsync("\(baseUrl)/login", loginModel)
        jwtService.storeTokensInKeychain(tokens: tokens)
        await HttpClient.shared.checkAuthentication()
        
        return true
    }
    
    func getUser(_ username: String) async throws -> User {
        let user: User = try await HttpClient.shared.getAsync("\(baseUrl)/\(username)")
        
        return user
    }
    
    
    func getUsersPage(page: Int = 1, size: Int = 10) async throws -> PagedList<User> {
        let users: PagedList<User> = try await HttpClient.shared.getAsync("\(baseUrl)?page=\(page)&size=\(size)")
        
        return users
    }
}
