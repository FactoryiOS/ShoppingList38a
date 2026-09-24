//
//  AppRoute.swift
//  ShoppingList38a
//
//  Created by Anastasia Belyakova on 21.09.2026.
//

enum AppRoute: Hashable, Identifiable {
    case shoppingList(ShoppingList.ID)
    
    case createShoppingList
    case editShoppingList(ShoppingList.ID)
    
    case createShoppingItem(ShoppingList.ID)
    case editShoppingItem(ShoppingItem.ID)
    
    var id: Self {
        self
    }
}
