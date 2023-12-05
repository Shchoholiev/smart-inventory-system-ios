//
//  GlobalUser.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/3/23.
//

import Foundation
import JWTDecode

class GlobalUser: ObservableObject {
    static let shared = GlobalUser()
    
    var id: String?
    var name: String?
    var email: String?
    var phone: String?
    var roles: [String] = []
    
    @Published var groupId: String?
    
    func setUserFromJwt(_ token: String) {
        do {
            let jwt = try decode(jwt: token)
            
            self.id = jwt.claim(name: "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier").string
            self.name = jwt.claim(name: "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name").string
            self.email = jwt.claim(name: "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress").string
            self.phone = jwt.claim(name: "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/mobilephone").string
            
            if let roles = jwt.claim(name: "http://schemas.microsoft.com/ws/2008/06/identity/claims/role").array {
                self.roles = roles
            }
            
            let groupId = UserDefaults.standard.string(forKey: "groupId")
            if let id = groupId {
                Task {
                    await setGroupId(id)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func setGroupId(_ value: String?) async {
        if value == nil {
            UserDefaults.standard.removeObject(forKey: "groupId")
        } else {
            UserDefaults.standard.set(value, forKey: "groupId")
        }
        await MainActor.run {
            groupId = value
        }
    }
    
    func clear() {
        self.id = nil
        self.name = nil
        self.email = nil
        self.phone = nil
        self.roles = []
        Task {
            await setGroupId(nil)
        }
    }
}
