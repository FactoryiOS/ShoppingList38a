//
//  ListItem.swift
//  ShoppingList38a
//
//  Created by Андрей Макалкин on 14.09.2026.
//

import SwiftData

@Model
final class ShoppingList {
    var name: String
    var icon: PurchaseIcon
    var color: PurchaseColor
    
    @Relationship(
        deleteRule: .cascade,
        inverse: \ShoppingItem.list
    )
    var items: [ShoppingItem]
    
    var purchasedCount: Int {
        items.filter { $0.isPurchased }.count
    }
    
    var totalCount: Int {
        items.count
    }
    
    init(
        name: String,
        icon: PurchaseIcon,
        color: PurchaseColor,
        items: [ShoppingItem] = []
    ) {
        self.name = name
        self.icon = icon
        self.color = color
        self.items = items
    }
}
