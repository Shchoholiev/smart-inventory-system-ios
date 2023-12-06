//
//  Shelf.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/5/23.
//

import Foundation

struct Shelf: Codable, Identifiable, Hashable {
    var id: String
    var name: String
    var isLitUp: Bool
    var groupId: String
    var deviceId: String
}
