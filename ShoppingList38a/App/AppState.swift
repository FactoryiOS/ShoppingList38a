//
//  AppState.swift
//  ShoppingList38a
//
//  Created by Андрей Макалкин on 19.09.2026.
//

import Foundation

@Observable
@MainActor
final class AppState {

    private let userDefaultsService: UserDefaultsService

    private(set) var isFirstLaunch: Bool

    var appColorScheme: AppColorScheme? {
        didSet {
            userDefaultsService.saveAppColorScheme(appColorScheme)
        }
    }

    init(
        userDefaultsService: UserDefaultsService = UserDefaultsService()
    ) {
        self.userDefaultsService = userDefaultsService

        isFirstLaunch = !userDefaultsService.fetchHasCompletedWelcome()
        appColorScheme = userDefaultsService.fetchAppColorScheme()
    }

    func completeWelcome() {
        isFirstLaunch = false
        userDefaultsService.saveHasCompletedWelcome()
    }
}
