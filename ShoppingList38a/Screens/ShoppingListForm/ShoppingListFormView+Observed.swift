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
        var name: String = "" {
            didSet {
                validateName()
            }
        }
        
        var selectedIcon: PurchaseIcon?
        var selectedColor: PurchaseColor?
        
        private(set) var nameErrorMessage: String?
        
        private let service: SwiftDataService
        private let currentShoppingList: ShoppingList?
        
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
        
        private var trimmedName: String {
            name.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        var isValid: Bool {
            !trimmedName.isEmpty
            && nameErrorMessage == nil
            && selectedIcon != nil
            && selectedColor != nil
        }
        
        var submitButtonTitle: String {
            currentShoppingList != nil ? "Сохранить" : "Создать"
        }
        
        var titleToolbar: String {
            currentShoppingList != nil ? "Редактировать список" : "Создать список"
        }
        
        func handleSave(completion: Completion) {
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
                : "Это название уже используется, пожалуйста, измените его."
            } catch {
                print("❌ [ShoppingListFormView] validateName: \(error)")
            }
        }
    }
}
