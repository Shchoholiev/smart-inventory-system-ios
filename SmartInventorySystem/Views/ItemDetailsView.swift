//
//  ItemDetailsView.swift
//  SmartInventorySystem
//
//  Created by Serhii Shchoholiev on 12/5/23.
//

import SwiftUI

struct ItemDetailsView: View {
    var item: Item
    
    var body: some View {
        Text("Items Details")
    }
}

#Preview {
    ItemDetailsView(item: Item())
}
