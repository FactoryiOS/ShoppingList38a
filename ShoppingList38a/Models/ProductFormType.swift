//
//  ProductFormType.swift
//  ShoppingList38a
//
//  Created by ivan on 2026-09-23.
//

enum ProductFormType {
    case create
    case edit(ShoppingItem)
    
    var displayName: String {
        switch self {
        case .create:
            "Создание товара"
        case .edit:
            "Редактировать"
        }
    }
}
