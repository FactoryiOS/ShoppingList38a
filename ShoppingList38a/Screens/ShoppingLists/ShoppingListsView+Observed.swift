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
    }
}
