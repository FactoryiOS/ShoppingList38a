//
//  ShoppingListView+Observed.swift
//  ShoppingList38a
//
//  Created by Albina Musugalieva on 19.09.2026.
//

import SwiftData
import SwiftUI

extension ShoppingListView {
    @MainActor
    @Observable
    final class Observed {
        
        // MARK: - State
        
        var searchText = ""
        
        // MARK: - Dependencies
        
        private let service: SwiftDataService
        private let shoppingList: ShoppingList
        
        // MARK: - Init
        
        init(
            service: SwiftDataService,
            shoppingList: ShoppingList
        ) {
            self.service = service
            self.shoppingList = shoppingList
        }
        
        // MARK: - Computed Properties
        
        var listTitle: String {
            shoppingList.name
        }
        
        var shoppingListID: ShoppingList.ID {
            shoppingList.id
        }
        
        var items: [ShoppingItem] {
            shoppingList.items
        }
        
        var filteredItems: [ShoppingItem] {
            let query = searchText.trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            
            guard !query.isEmpty else {
                return items
            }
            
            return items.filter {
                $0.name.localizedCaseInsensitiveContains(query)
            }
        }
        
        // MARK: - Actions
        
        func handleDeleteShoppingItem(
            _ shoppingItem: ShoppingItem
        ) {
            do {
                try service.deleteShoppingItem(shoppingItem)
            } catch {
                print("❌ [ShoppingListView] handleDeleteShoppingItem: \(error)")
            }
        }
        
        func handleToggleShoppingItem(
            _ shoppingItem: ShoppingItem
        ) {
            do {
                try service.toggleShoppingItem(shoppingItem)
            } catch {
                print("❌ [ShoppingListView] handleToggleShoppingItem: \(error)")
            }
        }
    }
}
