//
//  AppState.swift
//  ShoppingList38a
//
//  Created by Андрей Макалкин on 19.09.2026.
//

import Observation

@Observable
final class AppState {
    
    var appColorScheme: AppColorScheme? {
        didSet {
            userDefaultsService.saveAppColorScheme(appColorScheme)
        }
    }
    
    private let userDefaultsService: UserDefaultsService
    
    init(
        userDefaultsService: UserDefaultsService = UserDefaultsService()
    ) {
        self.userDefaultsService = userDefaultsService
        appColorScheme = userDefaultsService.fetchAppColorScheme()
    }

}
