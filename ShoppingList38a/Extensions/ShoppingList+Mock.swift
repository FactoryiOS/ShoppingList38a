//
//  ShoppingList+Mock.swift
//  ShoppingList38a
//
//  Created by Андрей Макалкин on 21.09.2026.
//

extension ShoppingList {
    static var mock: ShoppingList {
        ShoppingList(
            name: "Новый год",
            icon: .calendarNumber,
            color: .blue,
            items: makeItems(purchasedCount: 10, totalCount: 20)
        )
    }
    
    static var mocks: [ShoppingList] {
        [
            ShoppingList(
                name: "Новый год",
                icon: .calendarNumber,
                color: .blue,
                items: makeItems(purchasedCount: 10, totalCount: 20)
            ),
            ShoppingList(
                name: "Кошке",
                icon: .paw,
                color: .green,
                items: makeItems(purchasedCount: 1, totalCount: 4)
            ),
            ShoppingList(
                name: "Вечеринка",
                icon: .balloon,
                color: .yellow,
                items: makeItems(purchasedCount: 4, totalCount: 20)
            ),
            ShoppingList(
                name: "Поездка",
                icon: .airplane,
                color: .purple,
                items: makeItems(purchasedCount: 3, totalCount: 12)
            ),
            ShoppingList(
                name: "Продукты",
                icon: .cart,
                color: .red,
                items: makeItems(purchasedCount: 8, totalCount: 15)
            ),
            ShoppingList(
                name: "Спорт",
                icon: .barbell,
                color: .blue,
                items: makeItems(purchasedCount: 2, totalCount: 7)
            ),
            ShoppingList(
                name: "Подарки",
                icon: .gift,
                color: .green,
                items: makeItems(purchasedCount: 5, totalCount: 9)
            ),
            ShoppingList(
                name: "Работа",
                icon: .briefcase,
                color: .yellow,
                items: makeItems(purchasedCount: 1, totalCount: 6)
            ),
            ShoppingList(
                name: "Для машины",
                icon: .car,
                color: .purple,
                items: makeItems(purchasedCount: 0, totalCount: 5)
            ),
            ShoppingList(
                name: "Очень длинное название списка покупок",
                icon: .fastFood,
                color: .red,
                items: makeItems(purchasedCount: 7, totalCount: 18)
            )
        ]
    }
    
    private static func makeItems(
        purchasedCount: Int,
        totalCount: Int
    ) -> [ShoppingItem] {
        (0..<totalCount).map { index in
            ShoppingItem(
                name: "Товар \(index + 1)",
                count: 1,
                unit: .piece,
                isPurchased: index < purchasedCount
            )
        }
    }
}
