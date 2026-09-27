//
//  AppColorScheme.swift
//  ShoppingList38a
//
//  Created by Андрей Макалкин on 19.09.2026.
//

import Foundation

enum AppColorScheme: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case light
    case dark
    case system
    
    var displayName: String {
        switch self {
        case .light:
            String(localized: "Light")
        case .dark:
            String(localized: "Dark")
        case .system:
            String(localized: "System")
        }
    }
}
