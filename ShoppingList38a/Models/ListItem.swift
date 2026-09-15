//
//  ListItem.swift
//  ShoppingList38a
//
//  Created by Андрей Макалкин on 14.09.2026.
//

import Foundation

struct ListItem: Identifiable {
    let id: UUID
    var title: String
    var icon: PurchaseIcon
    var color: PurchaseColor
    var purchasedCount: Int
    var totalCount: Int
    
    init(
        id: UUID = UUID(),
        title: String,
        icon: PurchaseIcon,
        color: PurchaseColor,
        purchasedCount: Int,
        totalCount: Int
    ) {
        self.id = id
        self.title = title
        self.icon = icon
        self.color = color
        self.purchasedCount = purchasedCount
        self.totalCount = totalCount
    }
    
    static let mock = ListItem(
        title: "Новый год",
        icon: .calendarNumber,
        color: .blue,
        purchasedCount: 10,
        totalCount: 20
    )
}
