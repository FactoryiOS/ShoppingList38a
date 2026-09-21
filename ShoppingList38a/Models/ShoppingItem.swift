//
//  ShoppingItem.swift
//  ShoppingList38a
//
//  Created by Андрей Макалкин on 13.09.2026.
//

import SwiftData

@Model
final class ShoppingItem {
    var title: String
    var count: Int
    var unit: ShoppingItemUnit
    var isPurchased: Bool
    
    var list: ShoppingList?
    
    init(
        title: String,
        count: Int,
        unit: ShoppingItemUnit,
        isPurchased: Bool
    ) {
        self.title = title
        self.count = count
        self.unit = unit
        self.isPurchased = isPurchased
    }
}
