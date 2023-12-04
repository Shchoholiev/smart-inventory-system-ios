//
//  Group.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/3/23.
//

import Foundation

class Group: Codable {
    var id: String
    var name: String
    var description: String?

    init(_ id: String, _ name: String, _ description: String? = nil) {
        self.id = id
        self.name = name
        self.description = description
    }
}
