//
//  PurchaseColor+Color.swift
//  ShoppingList38a
//
//  Created by Андрей Макалкин on 14.09.2026.
//

import SwiftUI

extension PurchaseColor {
    var color: Color {
        switch self {
        case .green:
            Color(.additionalGreen)
        case .purple:
            Color(.additionalPurple)
        case .red:
            Color(.additionalRed)
        case .blue:
            Color(.additionalBlue)
        case .yellow:
            Color(.additionalYellow)
        }
    }
}
