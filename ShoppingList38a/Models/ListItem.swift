//
//  ListItem.swift
//  ShoppingList38a
//
//  Created by Андрей Макалкин on 14.09.2026.
//

import Foundation

struct ListItem: Identifiable {
    let id: UUID
    var name: String
    var icon: PurchaseIcon
    var color: PurchaseColor
    var purchasedCount: Int
    var totalCount: Int
    
    init(
        id: UUID = UUID(),
        name: String,
        icon: PurchaseIcon,
        color: PurchaseColor,
        purchasedCount: Int,
        totalCount: Int
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color
        self.purchasedCount = purchasedCount
        self.totalCount = totalCount
    }
    
    static let mock = ListItem(
        name: "Новый год",
        icon: .calendarNumber,
        color: .blue,
        purchasedCount: 10,
        totalCount: 20
    )
    
    static let mocks: [ListItem] = [
        ListItem(
            name: "Новый год",
            icon: .calendarNumber,
            color: .blue,
            purchasedCount: 10,
            totalCount: 20
        ),
        ListItem(
            name: "Кошке",
            icon: .paw,
            color: .green,
            purchasedCount: 1,
            totalCount: 4
        ),
        ListItem(
            name: "Вечеринка",
            icon: .balloon,
            color: .yellow,
            purchasedCount: 4,
            totalCount: 20
        ),
        ListItem(
            name: "Поездка",
            icon: .airplane,
            color: .purple,
            purchasedCount: 3,
            totalCount: 12
        ),
        ListItem(
            name: "Продукты",
            icon: .cart,
            color: .red,
            purchasedCount: 8,
            totalCount: 15
        ),
        ListItem(
            name: "Спорт",
            icon: .barbell,
            color: .blue,
            purchasedCount: 2,
            totalCount: 7
        ),
        ListItem(
            name: "Подарки",
            icon: .gift,
            color: .green,
            purchasedCount: 5,
            totalCount: 9
        ),
        ListItem(
            name: "Работа",
            icon: .briefcase,
            color: .yellow,
            purchasedCount: 1,
            totalCount: 6
        ),
        ListItem(
            name: "Для машины",
            icon: .car,
            color: .purple,
            purchasedCount: 0,
            totalCount: 5
        ),
        ListItem(
            name: "Очень длинное название списка покупок",
            icon: .fastFood,
            color: .red,
            purchasedCount: 7,
            totalCount: 18
        )
    ]
}
