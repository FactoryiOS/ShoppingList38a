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
        var isSortedByAlphabet = false
        
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
            if isSortedByAlphabet {
                return shoppingList.items.sorted {
                    $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
                }
            }
            
            return shoppingList.items.sorted {
                $0.createdAt < $1.createdAt
            }
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
        
        /// Формирует текст списка покупок для отправки.
        ///
        /// Формат результата:
        /// ```
        /// Новый год
        ///
        /// ✓ Мандарины — 2 кг
        /// ○ Сыр — 300 г
        /// ○ Сок — 2 л
        /// ```
        var shareText: String {
            let titleText = shoppingList.name
            let bodyText = items
                .map { item in
                    let checkmark = item.isPurchased ? "✓" : "○"
                    let name = item.name
                    let count = item.count
                    let unit = item.unit.displayName

                    return "\(checkmark) \(name) — \(count) \(unit)"
                }
                .joined(separator: "\n")
            
            return titleText + "\n\n" + bodyText
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
        
        func handleResetPurchasedItems() {
            do {
                try service.resetPurchasedItems(in: shoppingList)
            } catch {
                print("❌ [ShoppingListView] handleResetPurchasedItems: \(error)")
            }
        }
        
        func handleDeletePurchasedItems() {
            do {
                try service.deletePurchasedItems(in: shoppingList)
            } catch {
                print("❌ [ShoppingListView] handleDeletePurchasedItems: \(error)")
            }
        }
    }
}
