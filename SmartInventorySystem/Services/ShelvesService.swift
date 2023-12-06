//
//  ShelvesService.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/5/23.
//

import Foundation

class ShelvesService: ServiceBase {
    
    init() {
        super.init(url: "/shelves")
    }
    
    func getShelvesPage(_ groupId: String, _ page: Int = 1, _ size: Int = 20) async throws -> PagedList<Shelf> {
        let shelves: PagedList<Shelf> = try await HttpClient.shared.getAsync("\(baseUrl)?page=\(page)&size=\(size)&groupId=\(groupId)")
        
        return shelves
    }
    
    func getShelfItems(_ shelfId: String) async throws -> [Item] {
        let items: [Item] = try await HttpClient.shared.getAsync("\(baseUrl)/\(shelfId)/items")
        
        return items
    }
    
    func addItem(_ shelfId: String, _ item: Item) async throws -> Item {
        let createdItem: Item = try await HttpClient.shared.postAsync("\(baseUrl)/\(shelfId)/items", item)
        
        return createdItem
    }
}
