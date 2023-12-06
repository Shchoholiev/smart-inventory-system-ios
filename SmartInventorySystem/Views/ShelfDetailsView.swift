//
//  ShelfDetailsView.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/5/23.
//

import SwiftUI

struct ShelfDetailsView: View {
    var shelf: Shelf
    
    @State private var items: [Item] = []
    @State private var newItemName: String = ""
    @State private var newItemDescription: String = ""
    
    @State private var errorMessage: String? = nil
    @State private var isLoading = true

    private var shelvesService = ShelvesService()
    
    init(shelf: Shelf) {
        self.shelf = shelf
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Form {
                Section(header: Text("Name")) {
                    TextField("Item Name", text: $newItemName)
                }

                Section(header: Text("Description")) {
                    TextEditor(text: $newItemDescription)
                        .frame(minHeight: 70)
                }
            }
            .frame(height: 235)
            
            if let message = errorMessage {
                Text(message)
                    .foregroundColor(.red)
            }
            
            Button(action: addItem) {
                Image(systemName: "rectangle.stack.fill.badge.plus")
                    .symbolRenderingMode(.palette)
                    
                Text("Add Item")
            }
            .font(.system(size: 16, weight: .bold, design: .default))
            .padding([.top, .bottom], 10)
            .padding([.leading, .trailing], 16)
            .foregroundStyle(.white)
            .background(.blue)
            .opacity(newItemName.isEmpty ? 0.5 : 1)
            .cornerRadius(40)
            
            Divider()
            
            if isLoading {
                ProgressView()
                    .onAppear {
                        loadData()
                    }
            } else {
                if items.count > 0 {
                    ScrollView {
                        VStack(spacing: 10) {
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
                        }
                        .padding([.leading, .trailing, .bottom])
                        .padding([.top], 5)
                    }
                } else {
                    Text("No items")
                        .foregroundStyle(.gray)
                        .padding([.top, .bottom], 10)
                }
            }
            
            Spacer()
        }
        .padding(.top, 0)
        .padding([.leading, .top, .bottom])
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    private func loadData() {
        Task {
            do {
                let items = try await shelvesService.getShelfItems(shelf.id)
                self.items = items

                isLoading = false
            } catch let httpError as HttpError {
                errorMessage = httpError.message
                isLoading = false
            }
        }
    }
    
    private func addItem() {
        Task {
            do {
                let item = Item(name: newItemName, description: newItemDescription)
                let _ = try await shelvesService.addItem(shelf.id, item)
                
                newItemName = ""
                newItemDescription = ""
                
                let items = try await shelvesService.getShelfItems(shelf.id)
                self.items = items

                isLoading = false
            } catch let httpError as HttpError {
                errorMessage = httpError.message
                isLoading = false
            }
        }
    }
}

#Preview {
    ShelfDetailsView(shelf: Shelf(id: "", name: "", isLitUp: true, groupId: "", deviceId: ""))
}
