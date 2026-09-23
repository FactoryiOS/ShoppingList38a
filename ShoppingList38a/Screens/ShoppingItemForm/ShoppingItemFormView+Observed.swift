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
            ? "Создание товара"
            : "Редактировать"
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
        
        func handleSave(completion: Completion) {
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
            // TODO: Реализовать проверку дубликатов
            nameErrorMessage = nil
        }
    }
}
