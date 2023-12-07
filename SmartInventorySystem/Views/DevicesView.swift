//
//  DevicesView.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/5/23.
//

import SwiftUI

struct DevicesView: View {
    private var groupId = GlobalUser.shared.groupId ?? ""
    @State private var devices: [Device] = []
    @State private var newDeviceId: String = ""
    @State private var activateDeviceCount = 0
    
    @State private var errorMessage: String? = nil
    @State private var isLoading = true
    
    private var devicesService = DevicesService()
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Your Devices")
                .font(.title)
                .padding(.bottom)
            
            HStack {
                TextField("Device ID", text: $newDeviceId)
                    .padding([.leading, .trailing], 10)
                    .padding([.top, .bottom], 5)
                    .cornerRadius(7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(Color.gray, lineWidth: 1)
                    )

                Button(action: activateDevice) {
                    Image(systemName: "power.circle.fill")
                        .foregroundStyle(.white)
                        .symbolEffect(.bounce, value: activateDeviceCount)
                        
                    Text("Activate")
                        .foregroundColor(.white)
                }
                .padding([.trailing, .leading], 15)
                .padding([.top, .bottom], 7)
                .background(.blue)
                .opacity(newDeviceId.isEmpty ? 0.5 : 1)
                .cornerRadius(40)
                .disabled(newDeviceId.isEmpty)
            }
            .padding([.leading, .trailing])
            
            if let message = errorMessage {
                Text(message)
                    .foregroundColor(.red)
            }
            
            if isLoading {
                ProgressView()
                .onAppear {
                    loadData()
                }
            } else {
                if devices.count > 0 {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach($devices, id: \.id) { $device in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(device.name ?? "")
                                            .font(.headline)
                                        Text(device.type.toString())
                                            .font(.subheadline)
                                            .foregroundStyle(.gray)
                                        
                                    }
                                    
                                    Spacer()
                                }
                                .padding([.top, .bottom], 13)
                                .padding([.leading, .trailing], 17)
                                .background(Color(UIColor.secondarySystemGroupedBackground))
                                .cornerRadius(10)
                            }
                        }
                        .padding([.leading, .trailing, .bottom])
                        .padding([.top], 5)
                    }
                } else {
                    Text("No devices")
                        .foregroundStyle(.gray)
                        .padding([.top, .bottom], 10)
                }
            }
            
            Spacer()
        }
        .padding(.top)
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    private func loadData() {
        Task {
            do {
                let devices = try await devicesService.getDevicesPage(groupId)
                self.devices = devices.items

                isLoading = false
            } catch let httpError as HttpError {
                errorMessage = httpError.message
                isLoading = false
            }
        }
    }

    private func activateDevice() {
        Task {
            do {
                _ = try await devicesService.activateDevice(newDeviceId)
                
                let devices = try await devicesService.getDevicesPage(groupId)
                self.devices = devices.items
                
                errorMessage = nil
            } catch let httpError as HttpError {
                errorMessage = httpError.message
            }
        }
    }
}

#Preview {
    DevicesView()
}
