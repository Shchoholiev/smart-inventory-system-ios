//
//  ItemDetailsView.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/5/23.
//

import SwiftUI

struct ItemDetailsView: View {
    @State var item: Item
    // Used just as a workaround as binding was not working on a single item
    @State private var shelf: [Shelf] = []
    
    @State private var itemHistory: [ItemHistory] = []
    @State private var statusComment: String = ""
    
    @State private var errorMessage: String? = nil
    @State private var isEditMode = false
    @State private var isLoading = true
    @State private var isDeleted = false
    @State private var showingDeleteAlert = false

    private var itemsService = ItemsService()
    private var shelvesService = ShelvesService()
    
    init(item: Item) {
        self.item = item
//        self.shelf = Shelf(id: "", name: "", isLitUp: false, groupId: "", deviceId: "")
    }
    
    var body: some View {
        VStack(spacing: 10) {
            if isDeleted {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("Item deleted")
                            .foregroundStyle(.gray)
                        Spacer()
                    }
                    Spacer()
                }
                .background(Color(UIColor.systemGroupedBackground))
            } else {
                HStack {
                    if isEditMode {
                        Form {
                            Section(header: Text("Name")) {
                                TextField("Group Name", text: $item.name)
                                    .disabled(!isEditMode)
                            }
                            
                            Section(header: Text("Description")) {
                                TextEditor(text: Binding(
                                    get: { item.description ?? "" },
                                    set: { item.description = $0.isEmpty ? nil : $0 }
                                ))
                                .disabled(!isEditMode)
                                .frame(minHeight: 100)
                            }
                        }
                        .frame(height: 280)
                    } else {
                        VStack(alignment: .leading) {
                            if item.description != nil {
                                Text(item.description ?? "")
                                    .font(.headline)
                                    .padding(.bottom, 5)
                            }
                            
                            Text(LocalizedStringKey(item.isTaken ? "Taken" : "Available"))
                                .padding([.top, .bottom], 3)
                                .padding([.leading, .trailing], 6)
                                .font(.system(size: 14))
                                .bold()
                                .foregroundStyle(.white)
                                .background(item.isTaken ? Color.red : Color.green)
                                .cornerRadius(5)
                            
                            HStack {
                                TextField("Optional comment", text: $statusComment)
                                    .padding([.leading, .trailing], 10)
                                    .padding([.top, .bottom], 5)
                                    .cornerRadius(7)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 7)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                                
                                Button {
                                    toggleItemStatus()
                                } label: {
                                    Text(item.isTaken ? "Put Back" : "Take Item")
                                        .foregroundColor(.white)
                                }
                                .padding([.trailing, .leading], 15)
                                .padding([.top, .bottom], 7)
                                .background(.blue)
                                .cornerRadius(40)
                            }
                        }
                    }
                    
                    Spacer()
                    
                }
                .padding()
                
                HStack(spacing: 10) {
                    Button {
                        toggleLight()
                    } label: {
                        Label(shelf.first?.isLitUp ?? false ? "Turn Off Light" : "Turn On Light", systemImage: shelf.first?.isLitUp ?? false ? "lightbulb.slash.fill" : "lightbulb.fill")
                            .foregroundColor(.white)
                    }
                    .padding([.trailing, .leading], 15)
                    .padding([.top, .bottom], 7)
                    .background(.blue)
                    .cornerRadius(40)
                    
                    Button {
                        showingDeleteAlert = true
                    } label: {
                        Image(systemName: "trash.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                    }
                    .padding([.trailing, .leading], 9)
                    .padding([.top, .bottom], 7)
                    .background(.red)
                    .cornerRadius(40)
                    .alert(isPresented: $showingDeleteAlert) {
                        Alert(
                            title: Text("Confirm Deletion"),
                            message: Text("Are you sure you want to delete this item?"),
                            primaryButton: .destructive(Text("Delete")) {
                                deleteItem()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
                .padding([.leading, .trailing])
                
                if let message = errorMessage {
                    Text(message)
                        .foregroundColor(.red)
                }
                
                Divider()
                
                if isLoading {
                    ProgressView()
                        .onAppear {
                            loadData()
                        }
                } else {
                    if itemHistory.count > 0 {
                        ScrollView {
                            VStack(spacing: 10) {
                                ForEach($itemHistory, id: \.id) { $history in
                                    HStack(alignment: .top) {
                                        VStack(alignment: .leading) {
                                            HStack(spacing: 20) {
                                                Text(history.type.toString())
                                                    .font(.headline)
                                                
                                                Text(LocalizedStringKey(history.isTaken ? "Taken" : "Available"))
                                                    .padding([.top, .bottom], 3)
                                                    .padding([.leading, .trailing], 6)
                                                    .font(.system(size: 14))
                                                    .bold()
                                                    .foregroundStyle(.white)
                                                    .background(history.isTaken ? Color.red : Color.green)
                                                    .cornerRadius(5)
                                            }
                                            
                                            Text(itemsService.convertUTCDateToLocalDateString(utcDate: history.createdDateUtc))
                                                .font(.subheadline)
                                            
                                            Text(((history.comment ?? "").isEmpty ? "No comment" : history.comment)!)
                                                .font(.subheadline)
                                                .foregroundStyle(.gray)
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
        }
        .navigationTitle(item.name)
        .navigationBarItems(trailing:
            Button {
                toggleEdit()
            } label: {
                if !isEditMode {
                    Image(systemName: "square.and.pencil")
                } else {
                    Text("Save")
                }
            }
            .font(.system(size: 16, design: .default))
        )
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    private func loadData() {
        Task {
            do {
                let shelfDb = try await shelvesService.getShelf(item.shelfId)
                self.shelf = [shelfDb]
                
                let itemHistoryPage = try await itemsService.getItemHistoryPage(itemId: item.id, size: 100)
                self.itemHistory = itemHistoryPage.items

                isLoading = false
                errorMessage = nil
            } catch let httpError as HttpError {
                errorMessage = httpError.message
                isLoading = false
            }
        }
    }
    
    private func toggleEdit() {
        Task {
            do {
                if self.isEditMode {
                    let updatedItem = try await itemsService.updateItem(itemId: item.id, item: item)
                    self.item = updatedItem
                }
                
                isEditMode = !self.isEditMode
                errorMessage = nil
            } catch let httpError as HttpError {
                errorMessage = httpError.message
            }
        }
    }
    
    private func toggleItemStatus() {
        Task {
            do {
                let updatedItem = try await itemsService.updateItemStatus(itemId: item.id, isTaken: !item.isTaken, comment: statusComment)
                self.item = updatedItem
                statusComment = ""
                
                loadData()
                errorMessage = nil
            } catch let httpError as HttpError {
                errorMessage = httpError.message
            }
        }
    }
    
    private func toggleLight() {
        Task {
            do {
                let updatedShelf = try await shelvesService.controlLight(shelfd: shelf.first!.id, itemId: item.id, isOn: !shelf.first!.isLitUp)
                shelf = [updatedShelf]
                errorMessage = nil
            } catch let httpError as HttpError {
                errorMessage = "Error occured. Check if your shelf controller is on."
            }
        }
    }
    
    private func deleteItem() {
        Task {
            do {
                showingDeleteAlert = false
                
                try await itemsService.delete(itemId: item.id)
                isDeleted = true
                errorMessage = nil
            } catch let httpError as HttpError {
                errorMessage = httpError.message
            }
        }
    }
}

#Preview {
    ItemDetailsView(item: Item())
}
