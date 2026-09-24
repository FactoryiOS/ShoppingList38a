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
                WelcomeScreenView(
                    onComplete: appState.completeWelcome
                )
            } else {
                NavigationStack(path: $router.path) {
                    ShoppingListsView(
                        service: appState.swiftDataService
                    )
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
        .preferredColorScheme(
            appState.appColorScheme?.preferredColorScheme
        )
    }
    
    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .shoppingList(let shoppingListID):
            if let shoppingList = appState.swiftDataService.fetchShoppingList(
                by: shoppingListID
            ) {
                ShoppingListView(
                    service: appState.swiftDataService,
                    shoppingList: shoppingList
                )
            }
            
        case .createShoppingList:
            ShoppingListFormView(
                service: appState.swiftDataService,
                onComplete: router.dismissModal
            )
            
        case .editShoppingList(let shoppingListID):
            if let shoppingList = appState.swiftDataService.fetchShoppingList(
                by: shoppingListID
            ) {
                ShoppingListFormView(
                    service: appState.swiftDataService,
                    shoppingList: shoppingList,
                    onComplete: router.dismissModal
                )
            }
        
        case .createShoppingItem(let shoppingListID):
            if let shoppingList = appState.swiftDataService.fetchShoppingList(
                by: shoppingListID
            ) {
                ShoppingItemFormView(
                    service: appState.swiftDataService,
                    shoppingList: shoppingList,
                    onComplete: router.dismissModal
                )
            }

        case .editShoppingItem(let shoppingItemID):
            if let shoppingItem = appState.swiftDataService.fetchShoppingItem(
                by: shoppingItemID
            ),
               let shoppingList = shoppingItem.list {
                ShoppingItemFormView(
                    service: appState.swiftDataService,
                    shoppingList: shoppingList,
                    shoppingItem: shoppingItem,
                    onComplete: router.dismissModal
                )
            }
        }
    }
}
