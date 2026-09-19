//
//  AppState.swift
//  ShoppingList38a
//
//  Created by Anastasia Belyakova on 19.09.2026.
//

import Foundation

@Observable
@MainActor
final class AppState {
    private enum Keys {
        static let hasCompletedWelcome = "hasCompletedWelcome"
    }

    private let userDefaults: UserDefaults
    private(set) var isFirstLaunch: Bool

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        isFirstLaunch = !userDefaults.bool(forKey: Keys.hasCompletedWelcome)
    }

    func completeWelcome() {
        isFirstLaunch = false
        userDefaults.set(true, forKey: Keys.hasCompletedWelcome)
    }
}
