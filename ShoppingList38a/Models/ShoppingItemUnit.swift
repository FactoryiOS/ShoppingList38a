//
//  ShoppingItemUnit.swift
//  ShoppingList38a
//
//  Created by Андрей Макалкин on 13.09.2026.
//

enum ShoppingItemUnit: String, CaseIterable, Hashable, Codable {
    case piece
    case kilogram
    case gram
    case liter
    case milliliter
    
    var displayName: String {
        switch self {
        case .piece:
            "шт."
        case .kilogram:
            "кг"
        case .gram:
            "г"
        case .liter:
            "л"
        case .milliliter:
            "мл"
        }
    }
}
