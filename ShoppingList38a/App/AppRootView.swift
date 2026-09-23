//
//  AppRootView.swift
//  ShoppingList38a
//
//  Created by Anastasia Belyakova on 21.09.2026.
//

import SwiftUI

struct AppRootView: View {
    @Environment(AppState.self) private var appState
    @Environment(AppRouter.self) private var router

    var body: some View {
        @Bindable var router = router

        Group {
            if appState.isFirstLaunch {
                WelcomeScreenView(onComplete: appState.completeWelcome)
            } else {
                NavigationStack(path: $router.path) {
                    ShoppingListsView(lists: [])
                        .navigationDestination(for: AppRoute.self) { route in
                            destination(for: route)
                        }
                }
                .sheet(item: $router.presentedModal) { route in
                    NavigationStack {
                        destination(for: route)
                    }
                }
            }
        }
        .preferredColorScheme(appState.appColorScheme?.preferredColorScheme)
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .shoppingList(let list):
            Text(list.name)
        case .createShoppingList:
            ShoppingListFormView(onComplete: router.dismissModal)
        case .editShoppingList(let id):
            ShoppingListFormView(
                shoppingListId: id,
                onComplete: router.dismissModal
            )
        }
    }
}
