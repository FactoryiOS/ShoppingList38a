//
//  UserDefaultsService.swift
//  ShoppingList38a
//
//  Created by Андрей Макалкин on 19.09.2026.
//

import Foundation

final class UserDefaultsService {
    func saveHasCompletedWelcome() {
        UserDefaults.standard.set(
            true,
            forKey: UserDefaultsKey.hasCompletedWelcome.rawValue
        )
    }

    func fetchHasCompletedWelcome() -> Bool {
        UserDefaults.standard.bool(
            forKey: UserDefaultsKey.hasCompletedWelcome.rawValue
        )
    }

    func saveAppColorScheme(_ appColorScheme: AppColorScheme?) {
        if let appColorScheme {
            UserDefaults.standard.set(
                appColorScheme.rawValue,
                forKey: UserDefaultsKey.appColorScheme.rawValue
            )
        } else {
            UserDefaults.standard.removeObject(
                forKey: UserDefaultsKey.appColorScheme.rawValue
            )
        }
    }

    func fetchAppColorScheme() -> AppColorScheme? {
        guard let rawValue = UserDefaults.standard.string(
            forKey: UserDefaultsKey.appColorScheme.rawValue
        ) else {
            return nil
        }

        return AppColorScheme(rawValue: rawValue)
    }

}
