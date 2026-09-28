//
//  ShoppingListFormView+Observed.swift
//  ShoppingList38a
//
//  Created by Kislov Vadim on 19.09.2026.
//

import Foundation

extension ShoppingListFormView {
    @MainActor
    @Observable
    final class Observed {
        
        // MARK: - State
        
        var name: String = "" {
            didSet {
                validateName()
            }
        }
        
        var selectedIcon: PurchaseIcon?
        var selectedColor: PurchaseColor?
        
        private(set) var nameErrorMessage: LocalizedStringResource?
        
        // MARK: - Dependencies
        
        private let service: SwiftDataService
        private let currentShoppingList: ShoppingList?
        
        // MARK: - Init
        
        init(
            service: SwiftDataService,
            shoppingList: ShoppingList? = nil
        ) {
            self.service = service
            self.currentShoppingList = shoppingList

            if let shoppingList {
                name = shoppingList.name
                selectedIcon = shoppingList.icon
                selectedColor = shoppingList.color
            }
        }
        
        // MARK: - Computed Properties
        
        var isValid: Bool {
            !trimmedName.isEmpty
            && nameErrorMessage == nil
            && selectedIcon != nil
            && selectedColor != nil
        }
        
        var submitButtonTitle: LocalizedStringResource {
            currentShoppingList != nil
            ? .save
            : .create
        }
        
        var titleToolbar: LocalizedStringResource {
            currentShoppingList != nil
            ? .editListTitle
            : .createList
        }
        
        private var trimmedName: String {
            name.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        // MARK: - Actions
        
        func handleSave(completion: () -> Void) {
            guard
                isValid,
                let selectedIcon,
                let selectedColor
            else {
                return
            }
            
            do {
                if let currentShoppingList {
                    try service.updateShoppingList(
                        currentShoppingList,
                        name: trimmedName,
                        icon: selectedIcon,
                        color: selectedColor
                    )
                } else {
                    try service.createShoppingList(
                        name: trimmedName,
                        icon: selectedIcon,
                        color: selectedColor
                    )
                }
                
                completion()
            } catch {
                print("❌ [ShoppingListFormView] handleSave: \(error)")
            }
        }
        
        // MARK: - Validation
        
        private func validateName() {
            guard !trimmedName.isEmpty else {
                nameErrorMessage = nil
                return
            }
            
            do {
                let isAvailable = try service.isShoppingListNameAvailable(
                    trimmedName,
                    excluding: currentShoppingList
                )

                nameErrorMessage = isAvailable
                ? nil
                : .shoppingListDuplicateNameError
            } catch {
                print("❌ [ShoppingListFormView] validateName: \(error)")
            }
        }
    }
}
