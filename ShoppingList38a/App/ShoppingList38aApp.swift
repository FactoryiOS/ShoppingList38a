//
//  ShoppingList38aApp.swift
//  ShoppingList38a
//
//  Created by Nikita Tsomuk on 07.09.2026.
//

import SwiftUI
import SwiftData

@main
struct ShoppingList38aApp: App {
    @State private var appState = AppState()
    @State private var appRouter = AppRouter()

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environment(appState)
                .environment(appRouter)
                .preferredColorScheme(
                    appState.appColorScheme?.preferredColorScheme
                )
        }
        .modelContainer(
            appState.swiftDataService.modelContainer
        )
    }
}
