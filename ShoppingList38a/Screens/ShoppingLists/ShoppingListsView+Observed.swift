//
//  ShoppingListsView+Observed.swift
//  ShoppingList38a
//
//  Created by Андрей Макалкин on 22.09.2026.
//

import Foundation

extension ShoppingListsView {
    @MainActor
    @Observable
    final class Observed {
        
        // MARK: - State
        
        var isSortedByAlphabet = false
        
        // MARK: - Dependencies
        
        private let service: SwiftDataService
        
        // MARK: - Init
        
        init(service: SwiftDataService) {
            self.service = service
        }
        
        // MARK: - Actions
        
        func handleDeleteShoppingList(
            _ shoppingList: ShoppingList
        ) {
            do {
                try service.deleteShoppingList(shoppingList)
            } catch {
                print("❌ [ShoppingListsView] handleDeleteShoppingList: \(error)")
            }
        }
        
        func handleDuplicateShoppingList(
            _ shoppingList: ShoppingList
        ) {
            do {
                try service.duplicateShoppingList(shoppingList)
            } catch {
                print("❌ [ShoppingListsView] handleDuplicateShoppingList: \(error)")
            }
        }
        
        // MARK: - Helpers
        
        func sortLists(_ lists: [ShoppingList]) -> [ShoppingList] {
            guard isSortedByAlphabet else {
                return lists
            }

            return lists.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        }
    }
}
