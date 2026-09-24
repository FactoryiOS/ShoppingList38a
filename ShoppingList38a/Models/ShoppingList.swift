//
//  ShoppingList.swift
//  ShoppingList38a
//
//  Created by Андрей Макалкин on 14.09.2026.
//

import Foundation
import SwiftData

@Model
final class ShoppingList {
    var name: String
    var icon: PurchaseIcon
    var color: PurchaseColor
    var createdAt: Date = Date.now
    
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
        items: [ShoppingItem] = [],
        createdAt: Date = Date.now
    ) {
        self.name = name
        self.icon = icon
        self.color = color
        self.items = items
        self.createdAt = createdAt
    }
}
