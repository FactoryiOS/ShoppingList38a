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
            String(localized: "pcs")
        case .kilogram:
            String(localized: "kg")
        case .gram:
            String(localized: "g")
        case .liter:
            String(localized: "L")
        case .milliliter:
            String(localized: "mL")
        }
    }
}
