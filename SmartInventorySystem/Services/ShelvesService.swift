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
}
