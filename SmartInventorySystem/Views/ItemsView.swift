//
//  ItemsView.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/6/23.
//

import SwiftUI

struct ItemsView: View {    
    private var groupId = GlobalUser.shared.groupId ?? ""
    @State private var items: [Item] = []
    
    @State private var searchText = ""
    @State private var errorMessage: String? = nil
    @State private var isLoading = true

    private var itemsService = ItemsService()
    
    var body: some View {
        NavigationView {
            if isLoading {
                // Used to make full screen gray when loading
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    Spacer()
                }
                .background(Color(UIColor.systemGroupedBackground))
            } else {
                ScrollView {
                    VStack(spacing: 10) {
                        if items.count > 0 {
                            ForEach($items, id: \.id) { $item in
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading) {
                                        Text(item.name)
                                            .font(.headline)
                                        
                                        if item.description != nil {
                                            Text(item.description ?? "")
                                                .font(.subheadline)
                                                .foregroundStyle(.gray)
                                        }
                                        
                                        Text("\(item.isTaken ? "Taken" : "Available")")
                                            .padding([.top, .bottom], 3)
                                            .padding([.leading, .trailing], 6)
                                            .font(.system(size: 14))
                                            .bold()
                                            .foregroundStyle(.white)
                                            .background(item.isTaken ? Color.red : Color.green)
                                            .cornerRadius(5)
                                    }
                                    
                                    Spacer()
                                    
                                    NavigationLink(value: item) {
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
                            
                        } else {
                            VStack {
                                HStack {
                                    Spacer()
                                    Text("No items")
                                        .foregroundStyle(.gray)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding([.leading, .trailing, .bottom])
                    .padding([.top], 5)
                    .background(Color(UIColor.systemGroupedBackground))
                }
                .background(Color(UIColor.systemGroupedBackground))
                .navigationBarTitle("Search Items")
                .searchable(text: $searchText, prompt: "Search for items")
                .onChange(of: searchText) { oldValue, newValue in
                    loadData()
                }
            }
        }
        .onAppear {
            loadData()
        }
    }
    
    private func loadData() {
        Task {
            do {
                let itemsPage = try await itemsService.getItemsPage(groupId: groupId, size: 100, search: searchText)
                self.items = itemsPage.items

                isLoading = false
            } catch let httpError as HttpError {
                errorMessage = httpError.message
                isLoading = false
            }
        }
    }
}

#Preview {
    ItemsView()
}
