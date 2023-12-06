//
//  DevicesService.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/5/23.
//

import Foundation

class DevicesService: ServiceBase {
    
    init() {
        super.init(url: "/devices")
    }
    
    func activateDevice(_ deviceId: String) async throws -> Device {
        let deviceStatus = DeviceStatus(groupId: GlobalUser.shared.groupId ?? "", isActive: true)
        let activatedDevice: Device = try await HttpClient.shared.patchAsync("\(baseUrl)/\(deviceId)/status", deviceStatus)
        
        return activatedDevice
    }
    
    func getDevicesPage(_ groupId: String, _ page: Int = 1, _ size: Int = 10) async throws -> PagedList<Device> {
        let devices: PagedList<Device> = try await HttpClient.shared.getAsync("\(baseUrl)?page=\(page)&size=\(size)&groupId=\(groupId)")
        
        return devices
    }
}
