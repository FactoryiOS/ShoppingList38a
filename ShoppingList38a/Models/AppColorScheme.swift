//
//  AppColorScheme.swift
//  ShoppingList38a
//
//  Created by Андрей Макалкин on 19.09.2026.
//

enum AppColorScheme: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case light
    case dark
    case system
    
    var displayName: String {
        switch self {
        case .light:
            "Светлая"
        case .dark:
            "Темная"
        case .system:
            "Системная"
        }
    }
}
