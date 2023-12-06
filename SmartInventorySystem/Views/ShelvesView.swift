//
//  ShelvesView.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/5/23.
//

import SwiftUI

struct ShelvesView: View {
    private var groupId = GlobalUser.shared.groupId ?? ""
    @State private var shelves: [Shelf] = []
    
    @State private var errorMessage: String? = nil
    @State private var isLoading = true

    private var shelvesService = ShelvesService()
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Spacer()
                
                Text("Your Shelves")
                    .font(.title)
                    .padding(.bottom, 5)
                
                Spacer()
            }
            
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
                if shelves.count > 0 {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach($shelves, id: \.id) { $shelf in
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading) {
                                        Text(shelf.name)
                                            .font(.headline)
                                        Text("Light Status: \(shelf.isLitUp ? "ON" : "OFF")")
                                            .font(.subheadline)
                                            .foregroundStyle(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    NavigationLink(value: shelf) {
                                        Image(systemName: "info.circle.fill")
                                            .foregroundStyle(.blue)
                                            .font(.system(size: 24))
                                    }
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
                    Text("No shelves")
                        .foregroundStyle(.gray)
                        .padding([.top, .bottom], 10)
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    private func loadData() {
        Task {
            do {
                let shelves = try await shelvesService.getShelvesPage(groupId, 1, 30)
                self.shelves = shelves.items

                isLoading = false
            } catch let httpError as HttpError {
                errorMessage = httpError.message
                isLoading = false
            }
        }
    }
}

#Preview {
    ShelvesView()
}
