//
//  ShoppingItem+Mock.swift
//  ShoppingList38a
//
//  Created by Андрей Макалкин on 21.09.2026.
//

extension ShoppingItem {
    static var mockUnpurchased: ShoppingItem {
        ShoppingItem(
            title: "текст",
            count: 2,
            unit: .piece,
            isPurchased: false
        )
    }
    
    static var mockPurchased: ShoppingItem {
        ShoppingItem(
            title: "Чайник",
            count: 2,
            unit: .piece,
            isPurchased: true
        )
    }
}
