//
//  PagedList.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/5/23.
//

import Foundation

struct PagedList<T : Decodable> : Decodable {
    
    let totalPages: Int
    
    let items: [T]
    
    init(totalPages: Int, items: [T]) {
        self.totalPages = totalPages
        self.items = items
    }
}
