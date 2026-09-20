//
//  AppColorScheme+ColorScheme.swift
//  ShoppingList38a
//
//  Created by Андрей Макалкин on 19.09.2026.
//

import SwiftUI

extension AppColorScheme {
    var preferredColorScheme: ColorScheme? {
        switch self {
        case .light: .light
        case .dark: .dark
        case .system: nil
        }
    }
}
