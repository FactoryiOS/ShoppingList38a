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
            if appState.isFirstLaunch {
                WelcomeScreenView(
                    observed: WelcomeScreenView.Observed(
                        onStartButtonTap: appState.completeWelcome
                    )
                )
            } else {
                NavigationStack {
                    ShoppingListsView(lists: [])
                }
            }
        }
    }
}
