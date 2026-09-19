//
//  Purchase.swift
//  ShoppingList38a
//
//  Created by Kislov Vadim on 19.09.2026.
//

import Foundation

struct Purchase: Identifiable {
    let id: UUID
    let name: String
    let icon: PurchaseIcon
    let color: PurchaseColor
    
    init(
        id: UUID = UUID(),
        name: String,
        icon: PurchaseIcon,
        color: PurchaseColor,
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color
    }
    
    // TODO после перехода на SwiftData или удалить моки или перенести, по необходимости
    static let mockUUID = UUID()
    
    static let mockPurchases = [
        Purchase(id: mockUUID, name: "Первый список", icon: .alert, color: .green),
        Purchase(name: "Второй список", icon: .airplane, color: .red),
        Purchase(name: "Третий список", icon: .bandage, color: .purple)
    ]
}
