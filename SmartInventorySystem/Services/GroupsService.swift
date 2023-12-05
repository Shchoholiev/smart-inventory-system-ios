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
        await GlobalUser.shared.setGroupId(createdGroup.id)
        
        return createdGroup
    }

    func updateGroup(_ id: String, _ group: Group) async throws -> Group {
        let updatedGroup: Group = try await HttpClient.shared.putAsync("\(baseUrl)/\(id)", group)
        await GlobalUser.shared.setGroupId(updatedGroup.id)
        
        return updatedGroup
    }
    
    func getGroup(_ groupId: String) async throws -> Group {
        let group: Group = try await HttpClient.shared.getAsync("\(baseUrl)/\(groupId)")
        
        return group
    }
    
    func getGroupUsers(_ groupId: String) async throws -> [User] {
        let group: [User] = try await HttpClient.shared.getAsync("\(baseUrl)/\(groupId)/users")
        
        return group
    }
}
