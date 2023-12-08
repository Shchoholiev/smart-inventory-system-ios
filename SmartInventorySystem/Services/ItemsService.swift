//
//  ItemsService.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/6/23.
//

import Foundation

class ItemsService: ServiceBase {
    
    init() {
        super.init(url: "/items")
    }
    
    func getItemsPage(groupId: String, page: Int = 1, size: Int = 20, search: String) async throws -> PagedList<Item> {
        let url = "\(baseUrl)?page=\(page)&size=\(size)&groupId=\(groupId)&search=\(search)"
        let items: PagedList<Item> = try await HttpClient.shared.getAsync(url)
        
        return items
    }
    
    func getItem(itemId: String) async throws -> Item {
        let url = "\(baseUrl)/\(itemId)"
        let item: Item = try await HttpClient.shared.getAsync(url)
        
        return item
    }

    func updateItem(itemId: String, item: Item) async throws -> Item {
        let url = "\(baseUrl)/\(itemId)"
        let updatedItem: Item = try await HttpClient.shared.putAsync(url, item)
        
        return updatedItem
    }

    func updateItemStatus(itemId: String, isTaken: Bool, comment: String) async throws -> Item {
        let url = "\(baseUrl)/\(itemId)/status"
        let body = ItemStatus(isTaken: isTaken, comment: comment)
        let updatedItem: Item = try await HttpClient.shared.patchAsync(url, body)
        
        return updatedItem
    }

    func getItemHistoryPage(itemId: String, page: Int = 1, size: Int = 20) async throws -> PagedList<ItemHistory> {
        let url = "\(baseUrl)/\(itemId)/history?page=\(page)&size=\(size)"
        let historyPage: PagedList<ItemHistory> = try await HttpClient.shared.getAsync(url)
        
        return historyPage
    }

    func delete(itemId: String) async throws {
        let url = "\(baseUrl)/\(itemId)"
        let _: Dummy = try await HttpClient.shared.deleteAsync(url)
    }
}
