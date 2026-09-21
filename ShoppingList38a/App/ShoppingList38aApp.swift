//
//  ShoppingList38aApp.swift
//  ShoppingList38a
//
//  Created by Nikita Tsomuk on 07.09.2026.
//

import SwiftUI

@main
struct ShoppingList38aApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            Group {
                if appState.isFirstLaunch {
                    WelcomeScreenView(onComplete: appState.completeWelcome)
                } else {
                    NavigationStack {
                        ShoppingListsView(lists: [])
                    }
                }
            }
            .environment(appState)
            .preferredColorScheme(appState.appColorScheme?.preferredColorScheme)
        }
    }
}
