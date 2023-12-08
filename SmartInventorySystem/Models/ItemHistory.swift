//
//  ItemHistory.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/6/23.
//

import Foundation

import Foundation

struct ItemHistory: Codable, Identifiable {
    var id: UUID = UUID()
    var type: ItemHistoryType = .manual
    var isTaken: Bool = false
    var comment: String?
    var createdDateUtc: Date = Date()
    
    private enum CodingKeys: String, CodingKey {
        case type, isTaken, comment, createdDateUtc
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Decode each property except 'id'
        type = try container.decode(ItemHistoryType.self, forKey: .type)
        isTaken = try container.decode(Bool.self, forKey: .isTaken)
        comment = try container.decodeIfPresent(String.self, forKey: .comment)
        createdDateUtc = try container.decode(Date.self, forKey: .createdDateUtc)
    }
}

enum ItemHistoryType: Codable {
    case manual
    case scan
    case shelf
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let typeValue = try container.decode(Int.self)

        switch typeValue {
        case 0:
            self = .manual
        case 1:
            self = .scan
        case 2:
            self = .shelf
        default:
            self = .manual
        }
    }
    
    func toString() -> String {
        switch self {
        case .manual:
            return "Manually Recorded"
        case .scan:
            return "Scanned by Access Point"
        case .shelf:
            return "Motion on a Shelf"
        }
    }
}
