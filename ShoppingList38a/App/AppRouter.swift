//
//  AppRouter.swift
//  ShoppingList38a
//
//  Created by Anastasia Belyakova on 21.09.2026.
//

import Foundation

@Observable
@MainActor
final class AppRouter {
    var path: [AppRoute] = []
    var presentedModal: AppRoute?

    func push(_ route: AppRoute) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }

    func showModal(_ route: AppRoute) {
        presentedModal = route
    }

    func dismissModal() {
        presentedModal = nil
    }
}
