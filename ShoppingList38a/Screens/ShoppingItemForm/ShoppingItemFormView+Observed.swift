//
//  ProductFormView+Observed.swift
//  ShoppingList38a
//
//  Created by ivan on 2026-09-23.
//

import Foundation

extension ShoppingItemFormView {
    @MainActor
    @Observable
    final class Observed {
        
        // MARK: - State
        
        var nameText: String = "" {
            didSet {
                validateName()
            }
        }
        
        var amountText: String = ""
        var selectedUnit: ShoppingItemUnit = .piece
        
        private var allUniqueNames: Set<String> = []
        
        var suggestions: [String] {
            let query = trimmedName
            
            guard !query.isEmpty else {
                return []
            }
            
            return allUniqueNames
                .filter { name in
                    let isAlreadyInList = shoppingList.items.contains {
                        $0.id != currentShoppingItem?.id
                        && $0.name.lowercased() == name.lowercased()
                    }
                    
                    guard !isAlreadyInList else {
                        return false
                    }
                    
                    guard let range = name.localizedStandardRange(of: query) else {
                        return false
                    }
                    
                    return range.lowerBound == name.startIndex
                    && name.localizedCaseInsensitiveCompare(query) != .orderedSame
                }
                .sorted()
                .prefix(3)
                .map { $0 }
        }
        
        private(set) var nameErrorMessage: String?
        
        // MARK: - Dependencies
        
        private let service: SwiftDataService
        private let shoppingList: ShoppingList
        private let currentShoppingItem: ShoppingItem?
        
        // MARK: - Init
        
        init(
            service: SwiftDataService,
            shoppingList: ShoppingList,
            shoppingItem: ShoppingItem? = nil
        ) {
            self.service = service
            self.shoppingList = shoppingList
            self.currentShoppingItem = shoppingItem
            
            if let shoppingItem {
                nameText = shoppingItem.name
                amountText = "\(shoppingItem.count)"
                selectedUnit = shoppingItem.unit
            }
        }
        
        // MARK: - Computed Properties
        
        var title: String {
            currentShoppingItem == nil
            ? String(localized: "New Item")
            : String(localized: "Edit")
        }
        
        var isFormValid: Bool {
            isNameValid && isAmountValid
        }
        
        private var trimmedName: String {
            nameText.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        private var count: Int? {
            Int(amountText)
        }
        
        private var isNameValid: Bool {
            !trimmedName.isEmpty
            && nameErrorMessage == nil
        }
        
        private var isAmountValid: Bool {
            count != nil
        }
        
        // MARK: - Actions
        
        func handleSave(completion: () -> Void) {
            guard
                isFormValid,
                let count
            else {
                return
            }
            
            do {
                if let currentShoppingItem {
                    try service.updateShoppingItem(
                        currentShoppingItem,
                        name: trimmedName,
                        count: count,
                        unit: selectedUnit
                    )
                } else {
                    try service.addShoppingItem(
                        to: shoppingList,
                        name: trimmedName,
                        count: count,
                        unit: selectedUnit
                    )
                }
                
                completion()
            } catch {
                print("❌ [ShoppingItemFormView] handleSave: \(error)")
            }
        }
        
        // MARK: - Validation
        
        private func validateName() {
            let isDuplicateName = shoppingList.items.contains {
                $0.id != currentShoppingItem?.id && $0.name.lowercased() == trimmedName.lowercased()
            }
            
            nameErrorMessage = isDuplicateName
                ? String(localized: "This item is already in the list, add another")
                : nil
        }
        
        // MARK: - Auto-Suggestions
        
        func loadAllExistingItems() {
            self.allUniqueNames = service.fetchAllUniqueItemNames()
        }
    }
}
