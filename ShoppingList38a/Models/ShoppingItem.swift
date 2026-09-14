//
//  ShoppingItem.swift
//  ShoppingList38a
//
//  Created by Андрей Макалкин on 13.09.2026.
//

import Foundation

struct ShoppingItem: Identifiable {
    let id: UUID
    var title: String
    var count: Int
    var unit: ShoppingItemUnit
    var isPurchased: Bool
    
    init(
        id: UUID = UUID(),
        title: String,
        count: Int,
        unit: ShoppingItemUnit,
        isPurchased: Bool
    ) {
        self.id = id
        self.title = title
        self.count = count
        self.unit = unit
        self.isPurchased = isPurchased
    }
    
    static let mockUnpurchased = ShoppingItem(
        title: "текст",
        count: 2,
        unit: .piece,
        isPurchased: false
    )
    
    static let mockPurchased = ShoppingItem(
        title: "Чайник",
        count: 2,
        unit: .piece,
        isPurchased: true
    )
}
