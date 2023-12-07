//
//  Itm.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/5/23.
//

import Foundation

struct Item: Codable, Identifiable, Hashable {
    var id: String = ""
    var name: String = ""
    var description: String?
    var isTaken: Bool = false
    var shelfId: String = ""
}

struct ItemStatus: Encodable {
    let isTaken: Bool
    let comment: String
}
