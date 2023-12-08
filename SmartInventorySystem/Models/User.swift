//
//  User.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/4/23.
//

import Foundation

struct User: Codable, Identifiable {
    var id: String
    var name: String?
    var phone: String?
    var email: String?
    var groupId: String?
    var roles: [Role]
}
