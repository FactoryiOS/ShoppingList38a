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
        case .green: .additionalGreen
        case .purple: .additionalPurple
        case .red: .additionalRed
        case .blue: .additionalBlue
        case .yellow: .additionalYellow
        }
    }
}
