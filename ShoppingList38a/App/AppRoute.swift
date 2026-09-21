//
//  AppRoute.swift
//  ShoppingList38a
//
//  Created by Anastasia Belyakova on 21.09.2026.
//

import Foundation

enum AppRoute: Hashable, Identifiable {
    case shoppingList(ListItem)
    case createShoppingList
    case editShoppingList(UUID)

    var id: String {
        switch self {
        case .shoppingList(let list):
            "shoppingList-\(list.id.uuidString)"
        case .createShoppingList:
            "createShoppingList"
        case .editShoppingList(let id):
            "editShoppingList-\(id.uuidString)"
        }
    }
}
