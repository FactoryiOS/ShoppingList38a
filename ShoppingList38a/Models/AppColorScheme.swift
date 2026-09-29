//
//  AppColorScheme.swift
//  ShoppingList38a
//
//  Created by Андрей Макалкин on 19.09.2026.
//

import Foundation

enum AppColorScheme: String, CaseIterable, Identifiable {
    case light
    case dark
    case system

    var id: Self { self }

    var displayName: LocalizedStringResource {
        switch self {
        case .light:
            .themeLight
        case .dark:
            .themeDark
        case .system:
            .themeSystem
        }
    }
}
