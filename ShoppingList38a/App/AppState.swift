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
    let swiftDataService: SwiftDataService

    private(set) var isFirstLaunch: Bool

    var appColorScheme: AppColorScheme? {
        didSet {
            userDefaultsService.saveAppColorScheme(appColorScheme)
        }
    }

    init(
        userDefaultsService: UserDefaultsService = UserDefaultsService(),
        swiftDataService: SwiftDataService = SwiftDataService()
    ) {
        self.userDefaultsService = userDefaultsService
        self.swiftDataService = swiftDataService

        isFirstLaunch = !userDefaultsService.fetchHasCompletedWelcome()
        appColorScheme = userDefaultsService.fetchAppColorScheme()
    }

    func completeWelcome() {
        isFirstLaunch = false
        userDefaultsService.saveHasCompletedWelcome()
    }
}
