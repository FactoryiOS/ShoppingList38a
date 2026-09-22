//
//  ShoppingItem.swift
//  ShoppingList38a
//
//  Created by Андрей Макалкин on 13.09.2026.
//

import Foundation
import SwiftData

@Model
final class ShoppingItem {
    var name: String
    var count: Int
    var unit: ShoppingItemUnit
    var isPurchased: Bool
    var createdAt: Date = Date.now
    
    var list: ShoppingList?
    
    init(
        name: String,
        count: Int,
        unit: ShoppingItemUnit,
        isPurchased: Bool = false,
        createdAt: Date = Date.now
    ) {
        self.name = name
        self.count = count
        self.unit = unit
        self.isPurchased = isPurchased
        self.createdAt = createdAt
    }
}
