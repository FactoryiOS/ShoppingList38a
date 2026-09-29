//
//  ShoppingItemUnit.swift
//  ShoppingList38a
//
//  Created by Андрей Макалкин on 13.09.2026.
//

import Foundation

enum ShoppingItemUnit: String, CaseIterable, Hashable, Codable {
    case piece
    case kilogram
    case gram
    case liter
    case milliliter

    var displayName: String {
        switch self {
        case .piece:
            String(localized: .unitPieces)
        case .kilogram:
            String(localized: .unitKilograms)
        case .gram:
            String(localized: .unitGrams)
        case .liter:
            String(localized: .unitLiters)
        case .milliliter:
            String(localized: .unitMilliliters)
        }
    }
}
