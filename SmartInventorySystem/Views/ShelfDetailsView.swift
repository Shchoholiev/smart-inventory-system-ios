//
//  ShelfDetailsView.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/5/23.
//

import SwiftUI

struct ShelfDetailsView: View {
    var shelf: Shelf
    
    var body: some View {
        Text("ShelfDetailsView")
    }
}

#Preview {
    ShelfDetailsView(shelf: Shelf(id: "", name: "", isLitUp: true, groupId: "", deviceId: ""))
}
