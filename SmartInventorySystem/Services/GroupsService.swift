//
//  GroupsService.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/3/23.
//

import Foundation

class GroupsService: ServiceBase {
    
    init() {
        super.init(url: "/groups")
    }

    func createGroup(_ group: Group) async throws -> Group {
        let createdGroup: Group = try await HttpClient.shared.postAsync("\(baseUrl)", group)
        UserDefaults.standard.set(createdGroup.id, forKey: "groupId")
        
        return createdGroup
    }
    
    public func getGroupId() -> String? {
        return UserDefaults.standard.string(forKey: "groupId")
    }
}
